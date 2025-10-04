const express = require("express");
const bodyParser = require("body-parser");
const connectDB = require("./config/db");

const app = express();

app.use(bodyParser.json());

//kết nối DB

connectDB();

//Import route 
const userRoute = require("./routes/UserRoute");

// dùng router của useroute

app.use("/users",userRoute);

//chạy server
const PORT = 3000;
app.listen(PORT, () => console.log(`Server Đang chạy Trên Ở http://localhost:${PORT}`));
