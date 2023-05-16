$(document).ready(function(){
        $(".confirmtext").html("Do you want to pay $2500 by bank for the receipt that Pieter Post sends you?")
        $('#confirmreceiptmodal').modal()
        $('#accept-receipt').attr('data-price', 2500);
        $('#accept-receipt').attr('data-account', "bank");
 });
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
            <button type="button" class="btn btn-outline-secondary" id="sendreceipt" data-toggle="modal" data-target="#sendreceiptmodal">Send Receipt</button>
          </div>`)
        }
    } else if (event.data.action == "NearPlayers"){
        $.each(event.data.players, function (index, player) {
            $("#nearbyplayersselection").append('<option value="'+player.ped+'">'+player.name+'</option>');
        });
    } else if (event.data.action == "confirm"){
        var price = event.data.price
        var account = event.data.account
        var sender = event.data.sendername
        var funds = event.data.funds
        $(".confirmtext").html("Do you want to pay $"+price+" by "+account+" for the receipt that "+sender+" sends you?")
        $('#confirmreceiptmodal').modal()
        $('#accept-receipt').attr('data-price', price);
        $('#accept-receipt').attr('data-account', account);
        if (funds != 'N/A'){ $('#accept-receipt').attr('data-funds', funds); }
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
    var price = $("#receiptprice").val();
    $.post('https://ik-vehreport/SendReceipt', JSON.stringify({
        player: pid,
        price: price
    }))
})

$(document).on("click", "#sendreceipt", function () {
    $.post('https://ik-vehreport/GetNearPlayers', JSON.stringify({}))
})

$(document).on("click", "#accept-receipt", function () {
    var price = $('#accept-receipt').data('price')
    var account = $('#accept-receipt').data('account')
    if ($("#accept-receipt").data('funds')) { var funds = $("#accept-receipt").data('funds') } else {var funds = "N/A"}
    $.post('https://ik-vehreport/AcceptReceipt', JSON.stringify({
        price: price,
        account : account,
        funds: funds
    }))
})