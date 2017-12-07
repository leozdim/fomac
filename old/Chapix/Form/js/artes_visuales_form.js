Dropzone.autoDiscover = false;
var myDropzone = new Dropzone("#catalogo", {url : "/Form", dictDefaultMessage: "Arrastra tus archivos o da clic aquí"} );
    
myDropzone.on("addedfile", function(file) {
// setTimeout(function(){
//     console.log("File added "+file);
// }, 5000);
});

myDropzone.on("sending", function(file, xhr, formData) {
// Will send the filesize along with the file as POST data.
// formData.append("_action", 'upload_article_image');
// formData.append("article_id", $("#article_id").val());
});

myDropzone.on("queuecomplete",function(file){
// setTimeout(function(){
//     location.reload();
// },1000);
});

myDropzone.on("success",function(file,response){
// console.log(response);
});


