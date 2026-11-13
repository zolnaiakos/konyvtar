import express from 'express'
import kolcsonzesek from './routes/kolcsonzesek.js'
import konyvek from './routes/konyvek.js'
import olvasok from './routes/olvasok.js'

const app = express()
const port = 3000

app.use('/kolcsonzesek', kolcsonzesek)
app.use('/konyvek', konyvek)
app.use('/olvasok',olvasok)

app.listen(port,()=>{
    console.log(`Server is running: http://localhost:${port}`);
})