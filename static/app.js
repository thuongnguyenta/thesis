function bg_id(id){
    var x= document.getElementById(id).style.backgroundColor;
    if (x==""){
    document.getElementById(id).style.backgroundColor="lightgrey";
    }
    else{
        document.getElementById(id).style.backgroundColor=null;
    }
}


function display(id){
    
    // var x=id+1;
    var status =document.getElementById(id).style.display;
    if (status=="block")
        {  
            //  alert(status);
            document.getElementById(id).style.display =" none";
        }
    else { 
        //  alert(status);
            document.getElementById(id).style.display= "block";    
    }
}

function show_hide(id){
    
    var x=id+1;
    var status =document.getElementById(x).style.display;
    if (status=="block")
        {  
            //  alert(status);
            document.getElementById(x).style.display =" none";
        }
    else { 
        //  alert(status);
            document.getElementById(x).style.display= "block";    
    }
}
function change_image(id,src){
    var target_id=id+2;
    // alert (target_id);
    // alert (src);
    // var target_src=
    document.getElementById(target_id).src=src;
}