var factorial = function(n){
    if(n < 0)
        return 0;
    if(n == 0)
        return 1;
    return n * factorial(n - 1);
}

var jump = function(n){
    window.ParamsUtil.TestOneParameter(n)
}

function jump2(){
    window.ParamsUtil.TestOneParameter(n)
}
