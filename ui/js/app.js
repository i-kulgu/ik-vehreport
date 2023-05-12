window.addEventListener("message", function(event){
    if(event.data.action == "show"){
        var CarInfo = event.data.mods
        $(".vehreports-container").css("display", "block")
        $(".vehreports-content-name").html(CarInfo.vehname)
        $("#plate").html(CarInfo.plate)
        $("#engine").html(CarInfo.engine)
        $("#brakes").html(CarInfo.brakes)
        $("#transmission").html(CarInfo.transmission)
        $("#suspension").html(CarInfo.suspension)
        $("#armor").html(CarInfo.armor)
        $("#turbo").html(CarInfo.turbo)
    }
});

window.addEventListener("keydown", (e) => {
    if (e.code == "Escape" || e.key == "Escape") {
        $.post('https://ik-vehreport/close');
        $(".vehreports-container").css("display", "none")
        $(".vehreports-content-name").html("")
        $("#plate").html("")
        $("#engine").html("")
        $("#brakes").html("")
        $("#transmission").html("")
        $("#suspension").html("")
        $("#armor").html("")
        $("#turbo").html("")
    }
});