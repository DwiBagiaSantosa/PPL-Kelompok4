const express = require('express')
const mysql = require('mysql');
const session = require('express-session')

const port = 3001;

const connection = mysql.createConnection({
	host     : 'localhost',
	user     : 'root',
	password : '',
	database : 'fabbis'
});

connection.connect(function(err) {
	if (err) {
	  console.log("Cannot connect to mysql...")
	  throw err
	}
	console.log('Connected to mysql...')
});

const app = express();
app.use(session({secret: 'secret',}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(express.static('public'))

//set view engine to ejs
app.set('view engine', 'ejs');


app.get('/',(req,res)=> {
    res.render('admin/login');
})

app.post('/auth-mhs', (req, res) => {
    let username = req.body.username;
    let password = req.body.password;

    if (username && password) {
        connection.query('SELECT * FROM users WHERE username = ? AND password = ?', [username, password], (err, results, fields) => {
            if (err) throw err;

            if (results.length > 0) {
                req.session.loggedin = true;
                req.session.username = username;

                res.redirect('/user');
            } else {
                res.redirect('/')
            }
            res.end();
        });
    } else {
        res.send('Invalid')
        res.end();
    }
})

app.get('/dashboard',(req,res)=> {
    res.render('admin/dashboard_admin');
})

app.get('/user',(req,res)=> {
    res.render('user/dashboard_user');
})

app.get('/items',(req,res)=> {
    if(req.session.loggedin) {
        connection.query('SELECT * FROM items', (err, results) => {
            if (err) throw err;
            res.render('user/items', {
                dtd: results
            });
        })
    } else {
        res.redirect('/')
    }
    
})

app.post('/add/cart', (req, res) => {
    if(req.session.loggedin) {
        const data = req.body
        connection.query(`INSERT INTO transaction(items_id) values('${data.items_id}')`, (err, results, fields) => {
            if(err) throw err;
            res.redirect('/dashboard');
        })
    } else {
        res.redirect('/')
    }
})

app.get('/transaction',(req,res)=> {
    res.render('user/transaction');
})

app.get('/history',(req,res)=> {
    if(req.session.admin) {
        connection.query('SELECT transaction.id, shelf_name, name, qty, img, status from items LEFT JOIN shelves ON items.shelf_id = shelves.id GROUP BY items.id', function (error, results, fields) {
          if (error) throw error;
          res.render('admin/items/manage', {
            items: results
          })
        });
      } else {
        res.redirect("/")
      }  
    // res.render('user/history');
})

app.get('/logout',(req,res)=> {
    req.session.destroy();
	res.redirect('/');
})





app.listen(port, () => {
    console.log("Server started at port "+port)
    console.log("http://localhost:"+port)
})