const User = require("../models/UserModel");

const bcrypt = require("bcryptjs");

module.exports = {
    register: async (req,res)=> {
        try{
            const {phone,password} = req.body;
            
            //điều kiện khi người dùng nhập
            if (!phone || !password){
                return res.status(400).json({message:"vui lòng nhập đầy đủ thong tin"});
            }

            const existingUser = await User.findOne({ phone });
            
            if (existingUser){
                return res.status(400).json({message:"Số điện thoại đã tồn tại"});
            }

            const hashedPassword = await bcrypt.hash(password,10);

            const newUser= new User({phone, password: hashedPassword});
            await newUser.save();

            res.status(201).json({message: "Quý Khách Đã Đăng Ký Thành Công"});
        }
        catch(error){
            res.status(500).json({message: "Lỗi Sever",error});
        }
    },

    //tới xử lý đăn nhập
    login: async (req,res)=> {
        try{
            const {phone , password}= req.body;
            const user = await User.findOne({ phone});

            // điều kiện khi đăng nhập
            if (!user){
                return res.status(400).json({message:"Số Điện Thoại Không Tồn Tại"});
            }

            const isMatch = await bcrypt.compare(password, user.password);

            //điều kiện khi nhập mật khẩu
            if (!isMatch){
                return res.status(400).json({message:"Sai Mật Khẩu , vui lòng nhập lại"});
            }


            res.status(200).json({message:"Đăng Nhập Thành Công",user});
        }
        catch(error){
            res.status(500).json({message:"Lỗi server",error})
        }
    },
};