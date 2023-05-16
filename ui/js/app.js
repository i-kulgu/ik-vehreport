
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
        if (CarInfo.nos) {
            $("#nos").html(CarInfo.nos)
        } else {
            $("#nos-group").html("")
        }
        if (event.data.job == "true"){
            $(".logo-container").append(`<div class="receipt-btn-group">
            <button type="button" class="btn btn-outline-secondary" id="sendreceipt" data-toggle="modal" data-target="#exampleModalCenter">Send Receipt</button>
          </div>`)
        }
    } else if (event.data.action == "NearPlayers"){
        $.each(event.data.players, function (index, player) {
            $("#nearbyplayersselection").append('<option value="'+player.ped+'">'+player.name+'</option>');
        });
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
        $("#nos").html("")
    }
});

$(document).on("click", "#send-receipt", function () {
    var pid = $("#nearbyplayersselection").val();
    $.post('https://ik-vehreport/sendreceipt', JSON.stringify({
        player: pid,
    }))
})

$(document).on("click", "#sendreceipt", function () {
    $.post('https://ik-vehreport/GetNearPlayers', JSON.stringify({}))
})