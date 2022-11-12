const mongoose = require('mongoose');
const chefSchema = new mongoose.Schema({

    name:{
        type:String,
        required:true
    },
    ingredient:{
        type:String,
        required:true
    },
    preparation:{
        type:String,
        required:true
    },
     
    
});

module.exports = mongoose.model('Chef',chefSchema);