const express = require('express');
const app = express();
const cors = require('cors');

app.use(cors()); // allow access form any front end ( FOR NOW)


app.use(express.json());

app.use('/' , require("./routes"));


app.listen(3000, 'localhost' , () => {
    console.log(`Server started on port 3000`);
});
