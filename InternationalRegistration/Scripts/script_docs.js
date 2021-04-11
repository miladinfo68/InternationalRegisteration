var btnSubmitDocsIsDisabled = false;
var validFiles = ["jpg", "jpeg"];
var levels = {};
//var levels = {
//    "0": "-- انتخاب کنید --",
//    "1": "دیپلم",
//    "2": "پیش دانشگاهی",
//    "3": "کارشناسی",
//    "4": "کارشناسی ارشد",
//    "5": "دکتری"
//}
$.fn.hasAttr = function (name) { return this.attr(name) !== undefined; };

//overwrite alert 
window.alert = function (message, title) {
    $('<div />').text(message).dialog({
        modal: true,
        title: title,
        close: function () { $(this).dialog('destroy').remove(); }
    });
};

//##############################
//##############################

//add star beside of required file upload
function preRequiredDocsBySelectedCurrentLevel(selectedCurrentLevelIndex) {
    //debugger;
    var files = $(".uploadDocuments input[type=file]");
    files.each(function () {
        $(this).parent().closest('tr').find("span:not('.pass')").text("");//.remove();
    });
    var preRequireDegreeTitle = "0";
    switch (selectedCurrentLevelIndex) {
        case "1": preRequireDegreeTitle = "Diploma";
        case "2": preRequireDegreeTitle = "Diploma";
        case "3": preRequireDegreeTitle = "Diploma"; break;
        case "4": preRequireDegreeTitle = "Bachelor"; break;
        case "5": preRequireDegreeTitle = "Master"; break;
    }

    var file = files.filter('#' + preRequireDegreeTitle);
    var span = file.parent().closest('tr').find("span:not('.pass')").text(" * ").css({ "color": "red", "font-size": "30px" });
}

//##############################

function changeDropDownLastEducationDegree() {
    //var optionSelected = $('option:selected', this).attr('selected', true).siblings().removeAttr('selected');
    var optionSelected = $("#ddl_LastEducationDegree").find("option:selected");
    var selectedValue = optionSelected.val();
    var selectedText = optionSelected.text();

    var len = selectedItem = 0;
    switch (selectedValue) {
        case "0": len = 0; selectedItem = 0; break;
        case "1": len = 3; selectedItem = 3;
        case "2": len = 3; selectedItem = 3; break;
        case "3": len = 4; selectedItem = 4; break;
        case "4": len = 5; selectedItem = 4;
        case "5": len = 5; selectedItem = 4; break;
    }
    //generate options according to selected current level
    var currentLevel = $('#ddl_CurrentLevel');
    currentLevel.find('option').remove();


    var lang = $('#hdnCulture').val().split('-')[0];//window.location.pathname.split('/')[1];//$('#ddlSelectLang').find("option:selected").val().split('-');[0]
    var uri = "/" + lang + "/Documents/ResultMessage";
    $.ajax({
        url: uri,
        type: 'POST',
        data: { msgType: 'ListOfLevels' },
        success: function (result) {
            //debugger;
            levels = JSON.parse(result.MsgBody);
            //use levels hear after promise resolved
            //debugger;
            var option = "";
            var selectedProp = "";
            for (var i = 0; i <= len; i++) {
                //ignore Diploma , collage and phd
                if (i == 1 || i == 2 || i == 5) continue;
                selectedProp = i == selectedItem ? 'selected="selected"' : '';
                option = '<option value="' + i + '"' + selectedProp + '>' + levels[i] + '</option>';
                currentLevel.append(option);
            }

            var currentLevel_optionSelected = currentLevel.find("option:selected");
            var currentLevel_selectedValue = currentLevel_optionSelected.val();

            if (currentLevel_selectedValue != "0") {
                preRequiredDocsBySelectedCurrentLevel(currentLevel_selectedValue);
            } else {
                var span = $('.uploadDocuments input[type=file]').parent().closest('tr').find("span").not('.pass').text("");
            }

            $('#txt_LastEducationDegree').val(selectedValue);
            $('#txt_CurentLevel').val(currentLevel_selectedValue);

            //generateOptionsForCurrentLevel(len, selectedItem, levels);
        },
        error: function (jqXHR, exception) {
            //alert("WOW Error Occured !!!!", "Error Message")
             levels = {
                "0": "-- Select --",
                "1": "Diploma",
                "2": "Collage",
                "3": "Bachelor",
                "4": "Master",
                "5": "Phd"
             }
             var option = "";
             var selectedProp = "";
             for (var i = 0; i <= len; i++) {
                 //reject Diploma and collage
                 if (i == 1 || i == 2 || i == 5) continue;
                 selectedProp = i == selectedItem ? 'selected="selected"' : '';
                 option = '<option value="' + i + '"' + selectedProp + '>' + levels[i] + '</option>';
                 currentLevel.append(option);
             }

             var currentLevel_optionSelected = currentLevel.find("option:selected");
             var currentLevel_selectedValue = currentLevel_optionSelected.val();


        }
    });
   
}


//##############################

$("#ddl_LastEducationDegree").on('change', function (e) {
    changeDropDownLastEducationDegree();
});

//##############################

$("#ddl_CurrentLevel").on("change", function (e) {
    var optionSelected = $(this).find("option:selected");
    var selectedValue = optionSelected.val();
    //var selectedText = optionSelected.text();
    //debugger;
    if (selectedValue != "0") {
        preRequiredDocsBySelectedCurrentLevel(selectedValue);
    } else {
        var span = $('.uploadDocuments input[type=file]').parent().closest('tr').filter("span:not('.pass')").text("")
    }

    $('#txt_CurentLevel').val(selectedValue);
});

//##############################

$("#ddl_CountryList").on('change', function (e) {
    //var optionSelected = $('option:selected', this).attr('selected', true).siblings().removeAttr('selected');    
    var optionSelected = $(this).find("option:selected");
    var selectedValue = optionSelected.val();
    //var selectedText = optionSelected.text();
    $('#txt_CountryID').val(selectedValue);
});

//##############################

function checkUploaderValidation(uploader) {
    var isValid = true;
    var source = uploader.value;
    var fileSize = uploader.files[0].size;
    var ext = source.substring(source.lastIndexOf(".") + 1, source.length).toLowerCase();
    if (ext == validFiles[0] || ext == validFiles[1]) {
        //debugger;
        if (fileSize > 500000) {//more than 0.5 mb
            var lang = $('#hdnCulture').val().split('-')[0];//window.location.pathname.split('/')[1];//$('#ddlSelectLang').find("option:selected").val().split('-');[0]
            var uri = "/" + lang + "/Documents/ResultMessage";
            $.ajax({
                url: uri,
                type: 'POST',
                data: { msgType: 'SizeOfFileIsInvalid_ErrorTitle' },
                success: function (result) {
                    alert(result.MsgBody, result.MsgTilte);
                },
                error: function (jqXHR, exception) {
                    alert("WOW Error Occured !!!!", "Error Message")
                }
            });
            //alert("سایز فایل انتخابی باید کمتر از یک مگابایت باشد", "سایز فایل نا معتبر");
            document.getElementById(uploader.id).value = "";
            isValid = false;
        }
    } else {
        //var msg = "jpeg یا jpg باشد فرمت فایل انتخابی تنها می تواند ";    
        //alert(msg, "فرمت فایل نامعتبر");
        var lang = $('#hdnCulture').val().split('-')[0];//window.location.pathname.split('/')[1];//$('#ddlSelectLang').find("option:selected").val().split('-');[0]
        var uri = "/" + lang + "/Documents/ResultMessage";
        $.ajax({
            url: uri,
            type: 'POST',
            data: { msgType: 'FileFormatIsInvalid_ErrorTitle' },
            success: function (result) {
                alert(result.MsgBody, result.MsgTilte);
            },
            error: function (jqXHR, exception) {
                alert("WOW Error Occured !!!!", "Error Message")
            }
        });

        document.getElementById(uploader.id).value = "";
        isValid = false;
    }
    return isValid;
}

//##############################

$('.uploadDocuments input[type=file]').not(':disabled').on('change', function () {
    var uploderIsValid = checkUploaderValidation(this);
    var uploader = $(this);
    if (uploderIsValid) {
        //debugger;
        if (uploader.length) {
            var id = $(this).attr("id");
            var reader = new FileReader();
            reader.onload = function (e) {
                //debugger;
                //get img's tag that it's id is conyained destImgTag
                var $img = $('.uploadDocuments img[id*="img' + id + '"]'); //==>example  imgDiploma
                $img.attr('src', '');
                $img.attr('width', 230);
                $img.attr('height', 100);
                $img.attr('src', e.target.result);
            }
            reader.readAsDataURL(uploader[0].files[0]);
        }
    } else {
        uploader.val('');
    }
});
//##############################

//form validation
function formIsValid() {
    var res = true;
    //find reduire file uploads
    var files = $("span.ast-span:contains('*')").parent().closest('tr').find("input[type=file]").not(':disabled');
    for (var i = 0; i < files.length; i++) {
        //if file hadn't loaded break  
        var img = $("#img" + files[i].id);//==> for example imgDiploma
        var src = img.attr('src')
        if (files[i].disabled == false && (src == "" || src == "#")) {
            res = false;
            break;
        }
    }
    return res ? true : false;
}

//##############################

$('form#frmUploadDocuments').on('submit', function (e) {
    e.preventDefault();
    //debugger;
    //check if required documents uploaded
    if (!formIsValid()) {
        //alert("پر کردن موارد ستاره دار اجباری می باشد", "خطای اعتبار سنجی");
        var lang = $('#hdnCulture').val().split('-')[0];//window.location.pathname.split('/')[1];//$('#ddlSelectLang').find("option:selected").val().split('-');[0]//ar-IQ ,fa-IR ,...
        var uri = "/" + lang + "/Documents/ResultMessage";
        $.ajax({
            url: uri,
            type: 'POST',
            data: { msgType: 'FormValidation_ErrorTitle' },
            success: function (result) {
                alert(result.MsgBody, result.MsgTilte);
            },
            error: function (jqXHR, exception) {
                alert("WOW Error Occured !!!!", "Error Message")
            }
        });
        return false;
    }
    this.submit();
});

//##############################

$(document).ready(function () {
    //clear all required docs star except passport doc
    var span = $("span.ast-span").not('.pass').text("");
    var hiddens = $('.doc-wapper input[type=hidden]').val('0');
    changeDropDownLastEducationDegree();
    var imgs = $('.uploadDocuments img');

    //debugger;
    imgs.each(function () {
        var img = $(this);
        var file = img.closest("tr").find("input[type=file]")[0];
        if (img.attr('src') == '' || img.attr('src') == '#') {
            if ($(file).hasAttr('disabled')) $(file).removeAttr('disabled');
        } else {
            img.attr('width', 230);
            img.attr('height', 100);
            $(file).attr('disabled', true);
        }
    });
    var files = $('.uploadDocuments').find("input[type='file']:disabled");
    if (!btnSubmitDocsIsDisabled && files.length >= 3) {
        $('#btnSubmitDocs').prop('disabled', true);
        btnSubmitDocsIsDisabled = true;
    }
});



