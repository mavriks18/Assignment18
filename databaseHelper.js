
var mysql = require('mysql');
var loggeduserid = 0;
const express =require('express')
const app = express();
const queryString = require('querystring');
app.set('view-engine','ejs');
app.use(express.static(__dirname+'/Styles'));
app.use(express.urlencoded({ extended:false}));
app.get('/', (req,res)=>{
    res.render('index.ejs',{name :'Test'});
});
app.get('/login', (req,res) => {    
    res.render('login.ejs');
});
app.get('/productList', (req,res) => {
    var products = [];
    getAllProducts(function(err, resp){
        if(err)
        {
            res.render('index.ejs');
        }
        else
        {           
            res.render('productList.ejs', {products : resp[0]} );            
        }
    });
    
})
app.get('/cart',(req,res) => {
    res.render('cart.ejs');
});
app.get('/cart/:id/:count', (req,res) =>{       
    addUpdateCart(loggeduserid,req.params.id, req.params.count, function(err, resp){
        if(err){
            console.log(err);
            
            }
            else{
                res.render('cart.ejs' , {cartdetail : resp[0]});                   
                
                }
            
    });
    
});

app.get('/order', (req,res) => {
    placeOrder(loggeduserid, function(err, resp){
        if(err) throw err;
        else{
            res.render('order.ejs');
        }
    });

});


app.post('/login', (req,res)=>{
    authenticateUser(req.body.name , req.body.pwd, function(err,resp){
        if(err){
        console.log(err);
        }
        else{            
            if(resp[0]!=null && resp[0][0] != null)
            {
                loggeduserid = resp[0][0].id;
                res.redirect('/productList');
            }
            else{                
                res.redirect('/login');
            }
        }
    });
    
});
app.listen(3000);

var con = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"pass@word1", 
    databse:"estore"
});

function addUpdateCart(employeeId, itemId, count, callback )
{

    var sql = "Call estore.addUpdateCart(?,?,?)";
    var response ;
    con.query(sql,[employeeId,itemId,count], function(errQuery,result){
        if(errQuery)
        {
         callback(errQuery, null);
        }
        else
        {
         callback(null,result)   ;
        }
   
    
});
}


function addUpdateEmployeeOrder(id,cartId, status, callback)
{
  
    var sql = "Call estore.addUpdateEmployeeOrder(?,?,?)";
    con.query(sql,[id,cartId,status], function(errQuery,result){
        if(errQuery)
        {
         callback(errQuery, null);
        }
        else
        {
         callback(null,result);
        }
        
    
});
}

function authenticateUser(userid, pwd, callback)
{
 
    var sql = "Call estore.authenticateUser(?,?)";
    con.query(sql,[userid,pwd], function(errQuery,result){
        if(errQuery)
        {
         callback(errQuery, null);
        }
        else
        {
         callback(null,result)   ;
        }
   
});
}

function getAllProducts(callback)
{
 
    var sql = "Call estore.getAllProducts()";
    var response;
    con.query(sql, function(errQuery,result){
        if(errQuery) throw errQuery;
        callback(null, result);
    });

}

function placeOrder(userid, callback){
    var sql = "Call estore.placeOrder(?)"
    con.query(sql, [userid], function(errQuery, result){
        if(errQuery) throw errQuery;
        callback(null,result);
    });
}








