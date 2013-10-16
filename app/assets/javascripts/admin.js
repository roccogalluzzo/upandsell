   function showAlert(type, message){
         $('.alert-box')
         .html('<div class="alert alert-'+ type + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>');
    }