let express = require('express');

const app = express();

let router = express.Router();

let database = require('../database');

router.get("/num_empl_hired", function(request, response, next) {
    // Enviar texto plano a la página
    //response.send('List all sample data');
    let query = "SELECT * FROM employees_hired_by_department LIMIT 100";
    database.query(query, function(error, data) {
        if (error) {
            throw error;
        } else {
            response.render('num_empl_hired.ejs', {
                title: 'Number of Employees Hired for Each Job',
                action: 'list',
                sampleData: data
            });
        }
    });
});

router.get("/empl_hired_more_2021", function(request, response, next) {
    // Enviar texto plano a la página
    //response.send('List all sample data');
    let query = "SELECT * FROM employees_hired_more_than_mean_2021 LIMIT 100";
    database.query(query, function(error, data) {
        if (error) {
            throw error;
        } else {
            response.render('num_empl_hired.ejs', {
                title: 'Number of Employees Hired for Each Department That Hired More Employees Than The Mean of 2021',
                action: 'list',
                sampleData: data
            });
        }
    });
});

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

app.use(router);

app.listen(2100, () => {
    console.log("App is listening on port 2100");
}); // Iniciar en el puerto 2100


module.exports = router;
