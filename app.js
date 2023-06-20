const express = require("express");
const mysql = require("mysql");
const session = require("express-session");

const port = 3001;

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "fabbis",
  multipleStatements: true,
});


connection.connect(function (err) {
  if (err) {
    console.log("Cannot connect to mysql...");
    throw err;
  }
  console.log("Connected to mysql...");
});

const app = express();
app.use(session({ 
  secret: "secret",
  resave: true,
  saveUninitialized: true
 }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(express.static("public"));

//set view engine to ejs
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("login");
});

app.post("/auth-mhs", (req, res) => {
  let username = req.body.username;
  let password = req.body.password;

  if (username && password) {
    connection.query(
      "SELECT * FROM users WHERE username = ? AND password = ?",
      [username, password],
      (err, results, fields) => {
        if (err) throw err;

        if (results.length > 0) {
          req.session.loggedin = true;
          req.session.username = username;
          req.session.userid = results[0].id;
          // console.log(results[0].role);
          if (results[0].role == 1) {
            req.session.isadmin = true;
            req.session.loggedin = false;
            res.redirect("/dashboard/admin");
          } else {
            req.session.isadmin = false;
            res.redirect("/dashboard/user");
          }
          
          
        } else {
          res.redirect("/");
        }
        res.end();
      }
    );
  } else {
    res.send("Invalid");
    res.end();
  }
});

// USER ENDPOINT
app.get("/dashboard/user", (req, res) => {
  if(req.session.loggedin){
    q = `
    SELECT SUM(quantity) AS total FROM items;
    SELECT SUM(qty) AS borrowed FROM peminjaman WHERE status = 'Borrowed'`
    connection.query(q, (err, result) => {
      if (err) throw err;
      console.log(result)
      res.render("user/dashboard", {
        borrowed : result[1][0]['borrowed'], 
        data : result[0][0]['total']
      });
    })
  }else{
    res.redirect("/");
  }
  
});

app.get("/history/user", (req, res) => {
  const userid = req.session.userid;
  if(req.session.loggedin){
    connection.query(`SELECT * FROM peminjaman JOIN users on peminjaman.user_id = users.id JOIN items on peminjaman.items_id = items.id where status = 'Returned' AND user_id = ${userid}`,
    (err, results, fields) => {
      if (err) throw err;
      // console.log(results);

      // Mengubah format tanggal pada setiap objek hasil query
      const formattedResults = results.map((result) => {
        const date = new Date(result.borrow_date);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const formattedDate = `${year}-${month}-${day}`;

        const date2 = new Date(result.return_date);
        const year2 = date2.getFullYear();
        const month2 = String(date2.getMonth() + 1).padStart(2, "0");
        const day2 = String(date2.getDate()).padStart(2, "0");
        const formattedDate2 = `${year2}-${month2}-${day2}`;

        return {
          ...result,
          date: formattedDate,
          date2: formattedDate2
        };
      });

      // var d = new Date('2015-03-04T00:00:00.000Z');
      // console.log(d.getUTCHours()); // Hours
      // console.log(d.getUTCMinutes());
      // console.log(d.getUTCSeconds());

      res.render("user/history", {
        dtd: formattedResults
      });
    }
    )
  }
});

app.get("/borrowed/user", (req, res) => {
  if (req.session.loggedin) {
    const userid = req.session.userid;
    connection.query(
      `SELECT * FROM peminjaman JOIN users on peminjaman.user_id = users.id JOIN items on peminjaman.items_id = items.id where status = 'Borrowed' AND user_id = ${userid}`,
      (err, results, fields) => {
        if (err) throw err;
        // console.log(results);

        // Mengubah format tanggal pada setiap objek hasil query
        const formattedResults = results.map((result) => {
          const date = new Date(result.borrow_date);
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, "0");
          const day = String(date.getDate()).padStart(2, "0");
          const formattedDate = `${year}-${month}-${day}`;

          const date2 = new Date(result.return_date);
          const year2 = date2.getFullYear();
          const month2 = String(date2.getMonth() + 1).padStart(2, "0");
          const day2 = String(date2.getDate()).padStart(2, "0");
          const formattedDate2 = `${year2}-${month2}-${day2}`;

          return {
            ...result,
            date: formattedDate,
            date2: formattedDate2
          };
        });

        // var d = new Date('2015-03-04T00:00:00.000Z');
        // console.log(d.getUTCHours()); // Hours
        // console.log(d.getUTCMinutes());
        // console.log(d.getUTCSeconds());

        res.render("user/borrowed", {
          dtd: formattedResults
        });
      }
    );
  }
  //   res.render("user/transaction");
});

// ADMIN ENDPOINT
app.get("/dashboard/admin", (req, res) => {
  if(req.session.isadmin){
    q = `
    SELECT SUM(quantity) AS total FROM items;
    SELECT SUM(qty) AS borrowed FROM peminjaman WHERE status = 'Borrowed'`
    connection.query(q, (err, result) => {
      if (err) throw err;
      console.log(result)
      res.render("admin/dashboard", {
        borrowed : result[1][0]['borrowed'], 
        data : result[0][0]['total']
      });
    })
  } else {
    res.redirect("/");
  }
});

app.get("/items", (req, res) => {
  if (req.session.isadmin) {
    // console.log(req.session.userid);
    connection.query("SELECT * FROM items", (err, results) => {
      if (err) throw err;
      res.render("admin/items", {
        dtd: results,
      });
    });
  } else {
    res.redirect("/");
  }
});

app.post("/add/cart", (req, res) => {
  if (req.session.isadmin) {
    const data = req.body;
    const userid = req.session.userid;
    // console.log(data);
    connection.query(
      `INSERT INTO transactions(user_id, items_id, qty) values('${userid}','${data.items_id}', '1')`,
      (err, results, fields) => {
        if (err) throw err;
        res.redirect("/user");
      }
    );
  } else {
    res.redirect("/");
  }
});

app.get("/pinjaman/:id", (req, res) => {
  const q = `
  SELECT * FROM items WHERE id= ${req.params.id};
  select * from users where role = 0;` 
  if(req.session.isadmin) {
    connection.query(q, (err, results, fields) => {
      if (err) throw err;
      // console.log(results);
      res.render("admin/formpinjam", {
        items_id : req.params.id,
        items : results[0][0]['nama'],
        quantity : results[0][0]['quantity'],
        users : results[1]
      })
    })
    
  }
})

app.post("/pinjam", (req, res) => {
  const data = req.body;
  // console.log(req.params.quantity)
  const hasilkurang = req.body.quantity - req.body.qty
  const q = `
  INSERT INTO peminjaman(items_id, user_id, qty, borrow_date, return_date, status) values('${data.items_id}','${data.user_id}', '${data.qty}', '${data.borrow_date}', '${data.return_date}', 'Borrowed');
  UPDATE items SET quantity = '${hasilkurang}' WHERE id = '${data.items_id}'`

  if(req.session.isadmin) {
    connection.query(q, (err) => {
      if (err) throw err;
      res.redirect("/transaction");
    })
  }
})

app.get("/transaction", (req, res) => {
  if (req.session.isadmin) {
    // const userid = req.session.userid;
    connection.query(
      `SELECT * FROM peminjaman JOIN users on peminjaman.user_id = users.id JOIN items on peminjaman.items_id = items.id where status = 'Borrowed';`,
      (err, results, fields) => {
        if (err) throw err;
        console.log(results);

        // Mengubah format tanggal pada setiap objek hasil query
        const formattedResults = results.map((result) => {
          const date = new Date(result.borrow_date);
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, "0");
          const day = String(date.getDate()).padStart(2, "0");
          const formattedDate = `${year}-${month}-${day}`;

          const date2 = new Date(result.return_date);
          const year2 = date2.getFullYear();
          const month2 = String(date2.getMonth() + 1).padStart(2, "0");
          const day2 = String(date2.getDate()).padStart(2, "0");
          const formattedDate2 = `${year2}-${month2}-${day2}`;

          return {
            ...result,
            date: formattedDate,
            date2: formattedDate2
          };
        });

        // var d = new Date('2015-03-04T00:00:00.000Z');
        // console.log(d.getUTCHours()); // Hours
        // console.log(d.getUTCMinutes());
        // console.log(d.getUTCSeconds());

        res.render("admin/transaction", {
          dtd: formattedResults
        });
      }
    );
  }
  //   res.render("user/transaction");
});

app.post("/return/:id", (req, res) => {
  const id = req.params.id;
  const items_id = req.body.items_id
  console.log(id);
  const hasiltambah = Number(req.body.quantity) + Number(req.body.qty) 
  console.log(typeof(req.body.quantity)) 
  console.log(typeof(req.body.qty))
  console.log(typeof(hasiltambah))
  
  const q = `
  UPDATE peminjaman SET status = 'Returned' WHERE pinjam_id = ${id};
  UPDATE items SET quantity = '${hasiltambah}' WHERE id = ${items_id}`

  if(req.session.isadmin) {
    connection.query(q, (err) => {
      if (err) throw err;
      res.redirect("/dashboard/admin");
    })
  }
})

app.get("/history", (req, res) => {
  if(req.session.isadmin){
    connection.query(`SELECT * FROM peminjaman JOIN users on peminjaman.user_id = users.id JOIN items on peminjaman.items_id = items.id where status = 'Returned'`,
    (err, results, fields) => {
      if (err) throw err;
      // console.log(results);

      // Mengubah format tanggal pada setiap objek hasil query
      const formattedResults = results.map((result) => {
        const date = new Date(result.borrow_date);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const formattedDate = `${year}-${month}-${day}`;

        const date2 = new Date(result.return_date);
        const year2 = date2.getFullYear();
        const month2 = String(date2.getMonth() + 1).padStart(2, "0");
        const day2 = String(date2.getDate()).padStart(2, "0");
        const formattedDate2 = `${year2}-${month2}-${day2}`;

        return {
          ...result,
          date: formattedDate,
          date2: formattedDate2
        };
      });

      // var d = new Date('2015-03-04T00:00:00.000Z');
      // console.log(d.getUTCHours()); // Hours
      // console.log(d.getUTCMinutes());
      // console.log(d.getUTCSeconds());

      res.render("admin/history", {
        dtd: formattedResults
      });
    }
    )
  }
});

app.get("/logout", (req, res) => {
  req.session.destroy();
  res.redirect("/");
});

app.listen(port, () => {
  console.log("Server started at port " + port);
  console.log("http://localhost:" + port);
});
