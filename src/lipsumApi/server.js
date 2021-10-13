const express = require('express');
const lipsum = require('simple-lipsum');
const app = express();

const port = process.env.PORT || 3000;

express.get('/api/lipsum',(req,res) => {
    const sentence = lipsum.getParagraph(10,20);
    res.json(sentence);
});

app.listen(port,() => {
    console.log(`Server listening on port ${port}`);
});