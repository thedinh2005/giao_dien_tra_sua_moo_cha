const mongoose =  require("mongoose");
const connectDB = async () => {
    try {
        await mongoose.connect("mongodb://127.0.0.1:27017/flutterdb", {

            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.error("Hệ thống đã thành công kết nối MongoDataBase");
    }
    catch(err){
        console.error("Lỗi kết nối hệ thống với MongoDatabase")
    }
};

module.exports =connectDB