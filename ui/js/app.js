window.addEventListener("message", function(event){
    $(".vehreports-container").css("display", "block")
    if(event.data.action == "show"){
        var CarInfo = event.data.mods
        $(".vehreports-container").css("display", "block")
        $(".vehreports-content-name").html(CarInfo.vehname)
        $(".vehreports-content-plate").html(CarInfo.plate)
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
        $.post('https://ik-vehreports/close');
        $(".vehreports-container").css("display", "none")
        $(".vehreports-content-name").html("")
        $(".vehreports-content-plate").html("")
        $("#engine").html("")
        $("#brakes").html("")
        $("#transmission").html("")
        $("#suspension").html("")
        $("#armor").html("")
        $("#turbo").html("")
    }
});