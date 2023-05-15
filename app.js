const express = require('express')
// const session = require('express-session')

const app = express()

app.use(express.static('public'))

//set view engine to ejs
app.set('view engine', 'ejs');


app.get('/',(req,res)=> {
    res.render('admin/login');
})

app.get('/dashboard',(req,res)=> {
    res.render('admin/dashboard_admin');
})



const port = 3001;
app.listen(port, () => {
    console.log("Server started at port "+port)
    console.log("http://localhost:"+port)
})