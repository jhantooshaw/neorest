/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

$(document).ready(function() {
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 10000);

    $("#formID, #formImportID, #formSetID").validationEngine();
    $('.onlyinteger').bind('keypress', function(e) {
        return !(e.which !== 8 && e.which !== 0 &&
                (e.which < 48 || e.which > 57) && e.which !== 46);
    });

    $("#financial_year_id").on("change", function() {
        if (!$("#formSetID").validationEngine('validate')) {
            return false;
        }
        $.ajax({
            type: "GET",
            url: "get-locations/" + $(this).val(),
            dataType: "html"
        })
                .fail(function(msg) {
                    alert("Data fail: " + msg);
                })
                .done(function(msg) {
                    $("#location_select").html(msg);
                });
    });

    $("#location_id").on("change", function() {
        $("#outlet_id").removeClass('validate[required]');
        if (!$("#formID").validationEngine('validate')) {
            return false;
        }
        $.ajax({
            type: "GET",
            url: "/get-outlets/" + $(this).val(),
            dataType: "html"
        })
                .fail(function(msg) {
                    alert("Data fail: " + msg);
                })
                .done(function(msg) {
                    $("#outlet_select").html(msg);
                });
    });

    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

    //$('.datepicker').datepicker();
    //$(".datepicker").attr("readonly", "readonly");

    var start_date = $('#start_date').datepicker({
        format: 'yyyy-mm-dd',
        onRender: function(date) {
            // return date.valueOf() < now.valueOf() ? 'disabled' : '';
        }
    }).on('changeDate', function(ev) {
        if (ev.date.valueOf() > now.valueOf()) {
            var newDate = new Date(ev.date);
            newDate.setDate(newDate.getDate() + 1);
            end_date.setValue(newDate);
        }
        else if (ev.date.valueOf() > end_date.date.valueOf()) {
            var newDate = new Date(ev.date);
            newDate.setDate(newDate.getDate() + 1);
            end_date.setValue(newDate);
        }
        start_date.hide();
        $('#end_date')[0].focus();
    }).data('datepicker');

    var end_date = $('#end_date').datepicker({
        format: 'yyyy-mm-dd',
        onRender: function(date) {
            // return date.valueOf() <= satrt_date.date.valueOf() ? 'disabled' : '';
        }
    }).on('changeDate', function(ev) {
        if (ev.date.valueOf() < start_date.date.valueOf()) {
            var newDate = new Date(ev.date);
            newDate.setDate(newDate.getDate());
            start_date.setValue(newDate);
        }
        end_date.hide();
    }).data('datepicker');

});

function open_dialog(open, class_name) {
    var pop_up = "." + class_name;
    if (open === true) {
        $(pop_up).trigger('click');
    }
}