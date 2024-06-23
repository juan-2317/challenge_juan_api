const express = require('express'); // Importar módulo de express

const bodyParser = require('body-parser');

const csv = require('fast-csv');

const fs = require('fs');

const path = require('path');

const multer = require('multer'); // Ayuda a guardar archivos planos en un directorio específico

const mysql = require('mysql');

const app = express();

const router = express.Router();

app.use(bodyParser.urlencoded({extended: false}));

app.use(bodyParser.json());

let storage = multer.diskStorage({
    destination: (req, file, callback) => {
        callback(null, "uploads/");
    },
    filename: (req, file, callback) => {
        callback(null, file.fieldname + "-" + Date.now() + path.extname(file.originalname)); // Setear nombre dinámico
    }
});

let upload = multer({
    storage: storage
})
// Create the connection to MySQL
const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "",
    database: "challengeglobant"
})

router.post('/load_jobs/import-csv', upload.single('file'), (req, res) => { // 'file': Hace referencia al name del html
    console.log(req.file.path);
    uploadCsv("uploads/" + req.file.filename);
    res.send("Records imported!");
})

function uploadCsv(path) {
    let stream = fs.createReadStream(path);

    let csvDataColl = [];
    let fileStream = csv
        .parse(/*{ headers: false }*/)
        .on('data', function(data) { // 'data': Nombre del evento
            // Nota: Esta función es ciclica y va recorriendo el archivo para ir llenando el array
            
            csvDataColl.push(data);

        })
        .on('end', function() { // 'end': Evento que se dispara al final para finalmente insertar los datos en MySQL
            //csvDataColl.shift() // Remover el primer elemento del array, que corresponde a la cabecera del csv
            
            pool.getConnection((error, connection) => {
                if (error) {
                    console.log(error);
                } else {
                    let query = "INSERT INTO jobs(id, job) VALUES ?";

                    let iteraciones = parseInt(csvDataColl.length / 1000);
                    let i = 0;

                    for (i = 0; i < iteraciones; i++) {
                        connection.query(query, [csvDataColl.slice(i * 1000, (i + 1) * 1000)], (error, res) => {

                            if (error) {
                                console.log(error);
                            }
                        });
                    }

                    connection.query(query, [csvDataColl.slice(i * 1000, csvDataColl.length)], (error, res) => {
                        if (error) {
                            console.log(error);
                        }
                        
                    });
                }
            })

            fs.unlinkSync(path); // Eliminar archivo del servidor
        })

    stream.pipe(fileStream);
}

router.get('/load_jobs', (req, res, next) => {
    res.render("load_jobs.ejs");
})



app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

app.use(router);

app.listen(5000, () => {
    console.log("App is listening on port 5000");
}); // Iniciar en el puerto 5000

module.exports = router;
