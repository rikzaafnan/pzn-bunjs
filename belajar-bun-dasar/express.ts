import express from "express";

const app = express();

app.get('/', (req, res) => {
   const name = req.query["name"] || "World"
    res.send(`Hello ${name}!`);
})

app.listen(4999, () => {
    console.log("Server started on port 4999!");
})