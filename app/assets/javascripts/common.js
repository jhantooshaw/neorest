/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//$(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

$(document).on('ready page:load', function() {
//    setTimeout(function() {
//        $('.alert').fadeOut('slow');
//    }, 10000);

//    setInterval(function() {
//        get_response();
//    }, 15000);

    $("#formID, #formImportID, #formSetID, #formImportFinLocID").validationEngine();
    $('.onlyinteger').bind('keypress', function(e) {
        return !(e.which !== 8 && e.which !== 0 &&
                (e.which < 48 || e.which > 57) && e.which !== 46);
    });

    $("#financial_year_id, #financial_year_ids").on("change", function() {
        var filed_id = this.id, multiple_type = filed_id === 'financial_year_id' ? false : true;
        if (filed_id === 'financial_year_id' && !$("#formSetID").validationEngine('validate')) {
            return false;
        }

        $.ajax({
            type: "GET",
            url: "/get-locations/" + $(this).val(),
            dataType: "html",
            data: {multiple_type: multiple_type}
        })
                .fail(function(msg) {
                    alert("Data fail: " + msg);
                })
                .done(function(msg) {
                    if (filed_id === 'financial_year_id') {
                        $("#location_select").html(msg);
                    }
                    else {
                        $("#location_selects").html(msg);
                    }

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

    $('.import_button').on('click', function() {
        if (!$("#formID").validationEngine('validate')) {
            return false;
        }
        $.blockUI({message: '<h4><img src="/assets/loader.gif" alt="" /> Please wait, it will take few minutes...</h4>'});
    });

    $('.import_fin_loc_button').on('click', function() {
        if (!$("#formImportFinLocID").validationEngine('validate')) {
            return false;
        }
        $.blockUI({message: '<h4><img src="/assets/loader.gif" alt="" /> Please wait, it will take few minutes...</h4>'});
    });



});

function open_dialog(open, class_name) {
    var pop_up = "." + class_name;
    if (open === true) {
        $(pop_up).trigger('click');
    }
}

function get_response() {
    $.ajax({
        type: "GET",
        url: "/get-response",
        dataType: "html"
    })
            .fail(function(msg) {
                console.log("Data fail: " + msg);
            })
            .done(function(msg) {
                console.log(msg);
            });
}

function responsive_table(pagination) {
    $('.table-responsive').responsiveTable();
    if (pagination === true) {
        $('.pagination a').attr('data-remote', 'true');
        $('.pagination a').on('click', function() {
            $.blockUI({message: '<h4><img src="/assets/loader.gif" alt="" /> Please wait, it will take few minutes...</h4>'});
        });
    }
}