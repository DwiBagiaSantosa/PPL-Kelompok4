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

app.get('/user',(req,res)=> {
    res.render('user/dashboard_user');
})

app.get('/items',(req,res)=> {
    res.render('user/items');
})

app.get('/transaction',(req,res)=> {
    res.render('user/transaction');
})

app.get('/history',(req,res)=> {
    res.render('user/history');
})

app.get('/logout',(req,res)=> {
	res.redirect('/');
})




const port = 3001;
app.listen(port, () => {
    console.log("Server started at port "+port)
    console.log("http://localhost:"+port)
})