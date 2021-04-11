$(function () {
    if ($(window).width() >= 768) {
        $('#contentHeight, #tabs').css('minHeight', ($(window).height() - $('.headerBox').height() - $('.footerBox').height()) + 'px');
    }
    var disabledTabs = [1, 2, 3, 4, 5, 6];
    var editMode = false;
    $("#tabs").tabs({
        activate: function (event, ui) {
            if (editMode) {
                disabledTabs = [0, 1, 2, 3, 4, 5, 6];
                var active = $('#tabs').tabs('option', 'active');
                var activeId = $("#tabs ul>li a").eq(active).attr("href").split("-")[1];
                disabledTabs = disabledTabs.filter(function (x) { return x != parseInt(activeId) - 1; });
            }
            else {
                disabledTabs = [];
                for (var i = 6; i > (ui.newPanel[0].id.split("-")[1] - 1); i--) {
                    disabledTabs.push(i);
                }
            }
            $(this).tabs("option", "disabled", disabledTabs);
        }
    });
    $("#tabs").tabs("option", "disabled", disabledTabs);

    $(".dPicker").datepicker({
        changeMonth: true,
        changeYear: true,
        yearRange: "-100:+0",
        dateFormat: 'yy/mm/dd'
    });

    for (i = 0; i < 30; i++)
        $('#tblChosenFields > tbody').append('<tr><td></td><td></td><td></td><td></td><td></td></tr>');
    $('#tblChosenFields > tbody > tr').each(function (i, e) {
        if ($(e).find('td').length == 5)
            $(e).find('td:first-child').remove();
        $(e).prepend('<td>' + (i + 1) + '</td>');
    });
    $('#txtMobile').val($('#accountMobile').val());
    $('#txtCitizenMobile').val($('#accountMobile').val());
    $('#ddlCitizenMobileCode').val($('#accountMobileCode').val());
    $('#ddlIranMobileCode').val($('#accountMobileCode').val());
    $('#txtEmail').val($('#accountEmail').val());
    $('#txtCitizenEmail').val($('#accountEmail').val());

    $('#ddlMarriage').on('change', function () {
        if ($(this).val() == 3)
            $('#txtChildren').prop('disabled', true);
        else
            $('#txtChildren').prop('disabled', false);
    });

    $('#ddlCitizen').on('change', function () {
        if ($(this).val() == '999')
            $('#txtCitizen').show();
        else
            $('#txtCitizen').hide();
    });
    $('#ddlSecondCitizen').on('change', function () {
        if ($(this).val() == '999')
            $('#txtSecondCitizen').show();
        else
            $('#txtSecondCitizen').hide();
    });

    $('.removeField').on('click', function (e) {
        e.preventDefault();
    });

    $('#btnAddFamilyPerson').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        $.ajax({
            url: '/' + el.data('lang') + '/Request/AddFamilyPerson',
            type: 'POST',
            //data: {  },
            success: function (result) {
                $('#familyPersonsTable tbody').append(result);

                //it is need to load datepicker in generated text boxtes in server side
                $(".dPicker").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    yearRange: "-100:+0",
                    dateFormat: 'yy/mm/dd'
                });
            }
        });
        //alert();
    });



    //-- Number Only TextBox Start
    $.fn.inputFilter = function (inputFilter) {
        return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
            if (inputFilter(this.value)) {
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
            } else if (this.hasOwnProperty("oldValue")) {
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
            }
        });
    };
    //-- Number Only TextBox End

    //-- Email RegEx Start
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    //-- Email RegEx End

    //-- Validate Form Inputs Start
    $(".digitsOnly").inputFilter(function (value) { return /^\d*$/.test(value); });

    $(".onlyDecimal").inputFilter(function (value) { return /^(\d{ 1,2})(\.\d{1,2})?$/.test(value); });
    
    $('.emailFormat').on('blur', function () {
        var emailaddress = $(this).val(); if (!emailReg.test(emailaddress)) $(this).css({ border: '1px solid red', boxShadow: 'rgb(255, 85, 85) 0px 0px 10px 0px' }); else $(this).css({ border: '1px solid #ced4da', boxShadow: 'none' });
    });

    function ValidateTab(tabId) {
        var errorFields = [];
        var okFields = [];
        switch (tabId) {
            case 0:
                if ($('#txtFirstName').val() !== '') okFields.push($('#txtFirstName')); else errorFields.push($('#txtFirstName'));
                //if ($('#txtMiddleName').val() !== '') okFields.push($('#txtMiddleName')); else errorFields.push($('#txtMiddleName'));
                if ($('#txtLastName').val() !== '') okFields.push($('#txtLastName')); else errorFields.push($('#txtLastName'));
                if ($('#txtFatherName').val() !== '') okFields.push($('#txtFatherName')); else errorFields.push($('#txtFatherName'));
                if ($('#txtMotherName').val() !== '') okFields.push($('#txtMotherName')); else errorFields.push($('#txtMotherName'));
                //if ($('#txtGrandFatherName').val() !== '') okFields.push($('#txtGrandFatherName')); else errorFields.push($('#txtGrandFatherName'));
                if ($('#txtBirthDate').val() !== '' && isValidDate($('#txtBirthDate').val())) okFields.push($('#txtBirthDate')); else errorFields.push($('#txtBirthDate'));
                if ($('#txtBirthPlace').val() !== '') okFields.push($('#txtBirthPlace')); else errorFields.push($('#txtBirthPlace'));
                if ((($('#txtChildren').val() !== '' && $('#ddlMarriage').val() != 3) && $('#txtChildren').val() >= 0 && $('#txtChildren').val() < 255) || $('#ddlMarriage').val() == 3) okFields.push($('#txtChildren')); else errorFields.push($('#txtChildren'));
                if ($('#ddlGender').val() > 0) okFields.push($('#ddlGender')); else errorFields.push($('#ddlGender'));
                if ($('#ddlMarriage').val() > 0) okFields.push($('#ddlMarriage')); else errorFields.push($('#ddlMarriage'));
                if ($('#ddlPhysicalStatus').val() > 0) okFields.push($('#ddlPhysicalStatus')); else errorFields.push($('#ddlPhysicalStatus'));
                if ($('#ddlRelegion').val() > 0) okFields.push($('#ddlRelegion')); else errorFields.push($('#ddlRelegion'));

                break;
            case 1:
                if (($('#ddlCitizen').val() > 0 && $('#ddlCitizen').val() !== '999') || ($('#ddlCitizen').val() === '999' && $('#txtCitizen').val() !== '')) {
                    okFields.push($('#ddlCitizen'));
                    okFields.push($('#txtCitizen'));
                }
                else if ($('#ddlCitizen').val() === '999') {
                    okFields.push($('#ddlCitizen'));
                    errorFields.push($('#txtCitizen'));
                }
                else
                    errorFields.push($('#ddlCitizen'));
                if ($('#txtPassNo').val() !== '') okFields.push($('#txtPassNo')); else errorFields.push($('#txtPassNo'));
                break;
            case 2:
                var iranHome = 0, iranWork = 0, citizenHome = 0, citizenWork = 0;
                if ($('#txtIranHomeState').val() !== '' || $('#txtIranHomeCity').val() !== '' || $('#txtIranHomeStreet').val() !== '' || $('#txtIranHomePlaque').val() !== ''
                    || $('#txtIranHomePostalCode').val() !== '' || $('#txtIranHomePhone').val() !== '' || $('#ddlIranHomePhoneCode').val() !== ''
                    || ($('#txtEmail').val() !== '' && $('#txtEmail').val() != $('#accountEmail').val())
                    || ($('#txtMobile').val() !== '' && $('#txtMobile').val() != $('#accountMobile').val())
                    || ($('#ddlIranMobileCode').val() !== '' && $('#ddlIranMobileCode').val() !== $('#accountMobileCode').val()))
                    iranHome = 1;
                if ($('#txtIranWorkState').val() !== '' || $('#txtIranWorkCity').val() !== '' || $('#txtIranWorkStreet').val() !== '' || $('#txtIranWorkPlaque').val() !== ''
                    || $('#txtIranWorkPostalCode').val() !== '' || $('#txtIranWorkPhone').val() !== '' || $('#ddlIranWorkPhone').val() !== '')
                    iranWork = 1;
                if ($('#txtCitizenHomeState').val() !== '' || $('#txtCitizenHomeCity').val() !== '' || $('#txtCitizenHomeStreet').val() !== '' || $('#txtCitizenHomePlaque').val() !== ''
                    || $('#txtCitizenHomePostalCode').val() !== '' || $('#txtCitizenHomePhone').val() !== '' || $('#ddlCitizenHomePhoneCode').val() !== ''
                    || ($('#txtCitizenEmail').val() !== '' && $('#txtCitizenEmail').val() != $('#accountEmail').val())
                    || ($('#txtCitizenMobile').val() !== '' && $('#txtCitizenMobile').val() != $('#accountMobile').val())
                    || ($('#ddlCitizenMobileCode').val() !== '' && $('#ddlCitizenMobileCode').val() !== $('#accountMobileCode').val()))
                    citizenHome = 1;

                if ($('#txtCitizenWorkState').val() !== '' || $('#txtCitizenWorkCity').val() !== '' || $('#txtCitizenWorkStreet').val() !== '' || $('#txtCitizenWorkPlaque').val() !== ''
                    || $('#txtCitizenWorkPostalCode').val() !== '' || $('#txtCitizenWorkPhone').val() !== '' || $('#ddlCitizenWorkPhoneCode').val() !== '')
                    citizenWork = 1;

                if (iranHome == 1) {
                    if ($('#txtIranHomeState').val() !== '') okFields.push($('#txtIranHomeState')); else errorFields.push($('#txtIranHomeState'));
                    if ($('#txtIranHomeCity').val() !== '') okFields.push($('#txtIranHomeCity')); else errorFields.push($('#txtIranHomeCity'));
                    if ($('#txtIranHomeStreet').val() !== '') okFields.push($('#txtIranHomeStreet')); else errorFields.push($('#txtIranHomeStreet'));
                    if ($('#txtIranHomePhone').val() !== '') okFields.push($('#txtIranHomePhone')); else errorFields.push($('#txtIranHomePhone'));
                    if ($('#txtEmail').val() !== '' && emailReg.test($('#txtEmail').val())) okFields.push($('#txtEmail')); else errorFields.push($('#txtEmail'));
                    if ($('#txtMobile').val() !== '') okFields.push($('#txtMobile')); else errorFields.push($('#txtMobile'));
                    if ($('#ddlIranMobileCode').val() !== '') okFields.push($('#ddlIranMobileCode')); else errorFields.push($('#ddlIranMobileCode'));
                    if ($('#ddlIranHomePhoneCode').val() !== '') okFields.push($('#ddlIranHomePhoneCode')); else errorFields.push($('#ddlIranHomePhoneCode'));
                }
                else {
                    okFields.push($('#txtIranHomeState'));
                    okFields.push($('#txtIranHomeCity'));
                    okFields.push($('#txtIranHomeStreet'));
                    okFields.push($('#txtIranHomePhone'));
                    okFields.push($('#ddlIranHomePhoneCode'));
                    okFields.push($('#txtEmail'));
                    okFields.push($('#txtMobile'));
                    okFields.push($('#ddlIranMobileCode'));
                }
                if (iranWork == 1) {
                    if ($('#txtIranWorkState').val() !== '') okFields.push($('#txtIranWorkState')); else errorFields.push($('#txtIranWorkState'));
                    if ($('#txtIranWorkCity').val() !== '') okFields.push($('#txtIranWorkCity')); else errorFields.push($('#txtIranWorkCity'));
                    if ($('#txtIranWorkStreet').val() !== '') okFields.push($('#txtIranWorkStreet')); else errorFields.push($('#txtIranWorkStreet'));
                    if ($('#txtIranWorkPhone').val() !== '') okFields.push($('#txtIranWorkPhone')); else errorFields.push($('#txtIranWorkPhone'));
                    if ($('#ddlIranWorkPhone').val() !== '') okFields.push($('#ddlIranWorkPhone')); else errorFields.push($('#ddlIranWorkPhone'));
                }
                else {
                    okFields.push($('#txtIranWorkState'));
                    okFields.push($('#txtIranWorkCity'));
                    okFields.push($('#txtIranWorkStreet'));
                    okFields.push($('#txtIranWorkPhone'));
                    okFields.push($('#ddlIranWorkPhone'));
                }
                if (citizenHome == 1) {
                    if ($('#txtCitizenHomeState').val() !== '') okFields.push($('#txtCitizenHomeState')); else errorFields.push($('#txtCitizenHomeState'));
                    if ($('#txtCitizenHomeCity').val() !== '') okFields.push($('#txtCitizenHomeCity')); else errorFields.push($('#txtCitizenHomeCity'));
                    if ($('#txtCitizenHomeStreet').val() !== '') okFields.push($('#txtCitizenHomeStreet')); else errorFields.push($('#txtCitizenHomeStreet'));
                    if ($('#txtCitizenHomePhone').val() !== '') okFields.push($('#txtCitizenHomePhone')); else errorFields.push($('#txtCitizenHomePhone'));
                    if ($('#txtCitizenEmail').val() !== '' && emailReg.test($('#txtCitizenEmail').val())) okFields.push($('#txtCitizenEmail')); else errorFields.push($('#txtCitizenEmail'));
                    if ($('#txtCitizenMobile').val() !== '') okFields.push($('#txtCitizenMobile')); else errorFields.push($('#txtCitizenMobile'));
                    if ($('#ddlCitizenMobileCode').val() !== '') okFields.push($('#ddlCitizenMobileCode')); else errorFields.push($('#ddlCitizenMobileCode'));
                    if ($('#ddlCitizenHomePhoneCode').val() !== '') okFields.push($('#ddlCitizenHomePhoneCode')); else errorFields.push($('#ddlCitizenHomePhoneCode'));
                }
                else {
                    okFields.push($('#txtCitizenHomeState'));
                    okFields.push($('#txtCitizenHomeCity'));
                    okFields.push($('#txtCitizenHomeStreet'));
                    okFields.push($('#txtCitizenHomePhone'));
                    okFields.push($('#txtCitizenEmail'));
                    okFields.push($('#txtCitizenMobile'));
                    okFields.push($('#ddlCitizenMobileCode'));
                    okFields.push($('#ddlCitizenHomePhoneCode'));
                }
                if (citizenWork == 1) {
                    if ($('#txtCitizenWorkState').val() !== '') okFields.push($('#txtCitizenWorkState')); else errorFields.push($('#txtCitizenWorkState'));
                    if ($('#txtCitizenWorkCity').val() !== '') okFields.push($('#txtCitizenWorkCity')); else errorFields.push($('#txtCitizenWorkCity'));
                    if ($('#txtCitizenWorkStreet').val() !== '') okFields.push($('#txtCitizenWorkStreet')); else errorFields.push($('#txtCitizenWorkStreet'));
                    if ($('#txtCitizenWorkPhone').val() !== '') okFields.push($('#txtCitizenWorkPhone')); else errorFields.push($('#txtCitizenWorkPhone'));
                    if ($('#ddlCitizenWorkPhoneCode').val() !== '') okFields.push($('#ddlCitizenWorkPhoneCode')); else errorFields.push($('#ddlCitizenWorkPhoneCode'));
                }
                else {
                    okFields.push($('#txtCitizenWorkState'));
                    okFields.push($('#txtCitizenWorkCity'));
                    okFields.push($('#txtCitizenWorkStreet'));
                    okFields.push($('#txtCitizenWorkPhone'));
                    okFields.push($('#ddlCitizenWorkPhoneCode'));
                }

                if (iranHome == 0 && citizenHome == 0) {
                    //okFields = okFields.filter(function (value, index, arr) {
                    //    return value == $('#txtCitizenHomeState') || value == $('#txtCitizenHomeCity') || value == $('#txtCitizenHomeStreet') || value == $('#txtCitizenHomePhone')
                    //        || $('#txtCitizenEmail') || $('#txtCitizenMobile');
                    //});
                    for (var i = 0; i < okFields.length; i++) {
                        if (okFields[i].attr('id') === 'txtCitizenHomeState' || okFields[i].attr('id') === 'txtCitizenHomeCity' || okFields[i].attr('id') === 'txtCitizenHomeStreet'
                            || okFields[i].attr('id') === 'txtCitizenHomePhone' || okFields[i].attr('id') === 'txtCitizenEmail' || okFields[i].attr('id') === 'txtCitizenMobile'
                            || okFields[i].attr('id') === 'ddlCitizenMobileCode' || okFields[i].attr('id') === 'ddlCitizenHomePhoneCode') {
                            okFields.splice(i, 1);
                            i--;
                        }
                    }
                    if ($('#txtCitizenHomeState').val() !== '') okFields.push($('#txtCitizenHomeState')); else errorFields.push($('#txtCitizenHomeState'));
                    if ($('#txtCitizenHomeCity').val() !== '') okFields.push($('#txtCitizenHomeCity')); else errorFields.push($('#txtCitizenHomeCity'));
                    if ($('#txtCitizenHomeStreet').val() !== '') okFields.push($('#txtCitizenHomeStreet')); else errorFields.push($('#txtCitizenHomeStreet'));
                    if ($('#txtCitizenHomePhone').val() !== '') okFields.push($('#txtCitizenHomePhone')); else errorFields.push($('#txtCitizenHomePhone'));
                    if ($('#txtCitizenEmail').val() !== '' && emailReg.test($('#txtCitizenEmail').val())) okFields.push($('#txtCitizenEmail')); else errorFields.push($('#txtCitizenEmail'));
                    if ($('#txtCitizenMobile').val() !== '') okFields.push($('#txtCitizenMobile')); else errorFields.push($('#txtCitizenMobile'));
                    if ($('#ddlCitizenMobileCode').val() !== '') okFields.push($('#ddlCitizenMobileCode')); else errorFields.push($('#ddlCitizenMobileCode'));
                    if ($('#ddlCitizenHomePhoneCode').val() !== '') okFields.push($('#ddlCitizenHomePhoneCode')); else errorFields.push($('#ddlCitizenHomePhoneCode'));
                }
                break;
            case 3:
                var motherInfo = 0, recommenderInfo = 0;
                if ($('#txtMothersFirstName').val() !== '' || $('#txtMothersLastName').val() !== '' || $('#txtMothersFathersName').val() !== '' || $('#txtMothersGrandFathersName').val() !== ''
                    || $('#txtMothersBirthDate').val() !== '' || $('#txtMothersBirthPlace').val() !== '' || $('#txtMothersIdNumber').val() !== '' || $('#txtMothersIssuePlace').val() !== ''
                    || $('#txtMothersNationalCode').val() !== '' || $('#txtMothersMarriageType').val() > 0)
                    motherInfo = 1;
                if ($('#txtRecommenderFirstname').val() !== '' || $('#txtRecommenderLastname').val() !== ''
                    || $('#ddlRecommenderRelationship').val() !== ''
                    || $('#txtRecommenderFathersName').val() !== '' || $('#txtRecommenderGrandFathersName').val() !== '' || $('#txtRecommenderBirthDate').val() !== ''
                    || $('#ddlRecommenderDocumentType').val() > 0 || $('#txtRecommenderDocumentNumber').val() !== '' || $('#txtRecommenderJobTitle').val() !== ''
                    || $('#ddlRecommenderCitizenship').val() > 0
                )
                    recommenderInfo = 1;

                if (motherInfo == 1) {
                    if ($('#txtMothersFirstName').val() !== '') okFields.push($('#txtMothersFirstName')); else errorFields.push($('#txtMothersFirstName'));
                    if ($('#txtMothersLastName').val() !== '') okFields.push($('#txtMothersLastName')); else errorFields.push($('#txtMothersLastName'));
                    if ($('#txtMothersFathersName').val() !== '') okFields.push($('#txtMothersFathersName')); else errorFields.push($('#txtMothersFathersName'));
                    if ($('#txtMothersGrandFathersName').val() !== '') okFields.push($('#txtMothersGrandFathersName')); else errorFields.push($('#txtMothersGrandFathersName'));
                    if ($('#txtMothersBirthDate').val() !== '') okFields.push($('#txtMothersBirthDate')); else errorFields.push($('#txtMothersBirthDate'));
                    if ($('#txtMothersBirthPlace').val() !== '') okFields.push($('#txtMothersBirthPlace')); else errorFields.push($('#txtMothersBirthPlace'));
                    if ($('#txtMothersIdNumber').val() !== '') okFields.push($('#txtMothersIdNumber')); else errorFields.push($('#txtMothersIdNumber'));
                    if ($('#txtMothersIssuePlace').val() !== '') okFields.push($('#txtMothersIssuePlace')); else errorFields.push($('#txtMothersIssuePlace'));
                    if ($('#txtMothersNationalCode').val() !== '') okFields.push($('#txtMothersNationalCode')); else errorFields.push($('#txtMothersNationalCode'));
                    if ($('#txtMothersMarriageType').val() > 0) okFields.push($('#txtMothersMarriageType')); else errorFields.push($('#txtMothersMarriageType'));
                }
                else {
                    okFields.push($('#txtMothersFirstName'));
                    okFields.push($('#txtMothersLastName'));
                    okFields.push($('#txtMothersFathersName'));
                    okFields.push($('#txtMothersGrandFathersName'));
                    okFields.push($('#txtMothersBirthDate'));
                    okFields.push($('#txtMothersBirthPlace'));
                    okFields.push($('#txtMothersIdNumber'));
                    okFields.push($('#txtMothersIssuePlace'));
                    okFields.push($('#txtMothersNationalCode'));
                    okFields.push($('#txtMothersMarriageType'));
                }
                if (recommenderInfo == 1) {
                    if ($('#txtRecommenderFirstname').val() !== '') okFields.push($('#txtRecommenderFirstname')); else errorFields.push($('#txtRecommenderFirstname'));
                    if ($('#txtRecommenderLastname').val() !== '') okFields.push($('#txtRecommenderLastname')); else errorFields.push($('#txtRecommenderLastname'));
                    if ($('#txtRecommenderMobile').val() !== '') okFields.push($('#txtRecommenderMobile')); else errorFields.push($('#txtRecommenderMobile'));
                    if ($('#ddlRecommenderMobileCode').val() !== '') okFields.push($('#ddlRecommenderMobileCode')); else errorFields.push($('#ddlRecommenderMobileCode'));
                }
                else {
                    okFields.push($('#txtRecommenderFirstname'));
                    okFields.push($('#txtRecommenderLastname'));
                    okFields.push($('#txtRecommenderMobile'));
                    okFields.push($('#ddlRecommenderMobileCode'));
                }

                $('#familyPersonsTable > tbody > tr').each(function (i, e) {
                    if ($(e).find('td:nth-child(1) select').val() !== '' || $(e).find('td:nth-child(2) input').val() !== '' || $(e).find('td:nth-child(3) input').val() !== ''
                        || $(e).find('td:nth-child(4) input').val() !== '' || $(e).find('td:nth-child(5) input').val() !== '' || $(e).find('td:nth-child(6) input').val() !== ''
                        || $(e).find('td:nth-child(7) select').val() > 0 || $(e).find('td:nth-child(8) input').val() !== '' || $(e).find('td:nth-child(10) select').val() !== '') {
                        if ($(e).find('td:nth-child(1) select').val() !== '') okFields.push($(e).find('td:nth-child(1) select')); else errorFields.push($(e).find('td:nth-child(1) select'));
                        if ($(e).find('td:nth-child(2) input').val() !== '') okFields.push($(e).find('td:nth-child(2) input')); else errorFields.push($(e).find('td:nth-child(2) input'));
                        if ($(e).find('td:nth-child(3) input').val() !== '') okFields.push($(e).find('td:nth-child(3) input')); else errorFields.push($(e).find('td:nth-child(3) input'));
                        if ($(e).find('td:nth-child(4) input').val() !== '') okFields.push($(e).find('td:nth-child(4) input')); else errorFields.push($(e).find('td:nth-child(4) input'));
                        if ($(e).find('td:nth-child(5) input').val() !== '') okFields.push($(e).find('td:nth-child(5) input')); else errorFields.push($(e).find('td:nth-child(5) input'));
                        if ($(e).find('td:nth-child(6) input').val() !== '') okFields.push($(e).find('td:nth-child(6) input')); else errorFields.push($(e).find('td:nth-child(6) input'));
                        if ($(e).find('td:nth-child(7) select').val() > 0) okFields.push($(e).find('td:nth-child(7) select')); else errorFields.push($(e).find('td:nth-child(7) select'));
                        if ($(e).find('td:nth-child(8) input').val() !== '') okFields.push($(e).find('td:nth-child(8) input')); else errorFields.push($(e).find('td:nth-child(8) input'));
                        if ($(e).find('td:nth-child(10) select').val() !== '') okFields.push($(e).find('td:nth-child(10) select')); else errorFields.push($(e).find('td:nth-child(10) select'));
                    }
                    else {
                        okFields.push($(e).find('td:nth-child(1) select'));
                        okFields.push($(e).find('td:nth-child(2) input'));
                        okFields.push($(e).find('td:nth-child(3) input'));
                        okFields.push($(e).find('td:nth-child(4) input'));
                        okFields.push($(e).find('td:nth-child(5) input'));
                        okFields.push($(e).find('td:nth-child(6) input'));
                        okFields.push($(e).find('td:nth-child(7) select'));
                        okFields.push($(e).find('td:nth-child(8) input'));
                        okFields.push($(e).find('td:nth-child(10) select'));
                    }
                });
                break;
            case 4:
                var diploma = 0, preuniversity = 0, bachelor = 0, master = 0, phd = 0;
                if ($('#txtDiplomaWrittenAverage').val() !== '' || $('#txtDiplomaPlace').val() !== '' || $('#txtDiplomaField').val() !== ''
                    || $('#txtDiplomaTotalAverage').val() !== '')
                    diploma = 1;
                if ($('#txtPreUniversityAverage').val() !== '' || $('#txtPreuniversityField').val() !== '')
                    preuniversity = 1;
                if ($('#txtBachelorField').val() !== '' || $('#txtBachelorUniversity').val() !== '' || $('#txtBachelorCountry').val() !== ''
                    || $('#txtBachelorAverage').val() !== '')
                    bachelor = 1;
                if ($('#txtMasterField').val() !== '' || $('#txtMasterUniversity').val() !== '' || $('#txtMasterCountry').val() !== ''
                    || $('#txtMasterAverage').val() !== '')
                    master = 1;
                if ($('#txtDoctorateField').val() !== '' || $('#txtDoctorateUniversity').val() !== '' || $('#txtDoctorateCountry').val() !== ''
                    || $('#txtDoctorateAverage').val() !== '')
                    phd = 1;

                if (diploma == 1) {
                    if ($('#txtDiplomaWrittenAverage').val() !== '' && $('#txtDiplomaWrittenAverage').val() >= 0 && $('#txtDiplomaWrittenAverage').val() <= 100) okFields.push($('#txtDiplomaWrittenAverage')); else errorFields.push($('#txtDiplomaWrittenAverage'));
                    if ($('#txtDiplomaPlace').val() !== '') okFields.push($('#txtDiplomaPlace')); else errorFields.push($('#txtDiplomaPlace'));
                    if ($('#txtDiplomaField').val() !== '') okFields.push($('#txtDiplomaField')); else errorFields.push($('#txtDiplomaField'));
                    if ($('#txtDiplomaTotalAverage').val() !== '' && $('#txtDiplomaTotalAverage').val() >= 0 && $('#txtDiplomaTotalAverage').val() <= 100) okFields.push($('#txtDiplomaTotalAverage')); else errorFields.push($('#txtDiplomaTotalAverage'));
                }
                else {
                    okFields.push($('#txtDiplomaWrittenAverage'));
                    okFields.push($('#txtDiplomaPlace'));
                    okFields.push($('#txtDiplomaField'));
                    okFields.push($('#txtDiplomaTotalAverage'));
                }
                if (preuniversity == 1) {
                    if ($('#txtPreUniversityAverage').val() !== '' && $('#txtPreUniversityAverage').val() >= 0 && $('#txtPreUniversityAverage').val() <= 100) okFields.push($('#txtPreUniversityAverage')); else errorFields.push($('#txtPreUniversityAverage'));
                    if ($('#txtPreuniversityField').val() !== '') okFields.push($('#txtPreuniversityField')); else errorFields.push($('#txtPreuniversityField'));
                }
                else {
                    okFields.push($('#txtPreUniversityAverage'));
                    okFields.push($('#txtPreuniversityField'));
                }
                if (bachelor == 1) {
                    if ($('#txtBachelorField').val() !== '') okFields.push($('#txtBachelorField')); else errorFields.push($('#txtBachelorField'));
                    if ($('#txtBachelorUniversity').val() !== '') okFields.push($('#txtBachelorUniversity')); else errorFields.push($('#txtBachelorUniversity'));
                    if ($('#txtBachelorCountry').val() !== '') okFields.push($('#txtBachelorCountry')); else errorFields.push($('#txtBachelorCountry'));
                    if ($('#txtBachelorAverage').val() !== '' && $('#txtBachelorAverage').val() >= 0 && $('#txtBachelorAverage').val() <= 100) okFields.push($('#txtBachelorAverage')); else errorFields.push($('#txtBachelorAverage'));
                }
                else {
                    okFields.push($('#txtBachelorField'));
                    okFields.push($('#txtBachelorUniversity'));
                    okFields.push($('#txtBachelorCountry'));
                    okFields.push($('#txtBachelorAverage'));
                }
                if (master == 1) {
                    if ($('#txtMasterField').val() !== '') okFields.push($('#txtMasterField')); else errorFields.push($('#txtMasterField'));
                    if ($('#txtMasterUniversity').val() !== '') okFields.push($('#txtMasterUniversity')); else errorFields.push($('#txtMasterUniversity'));
                    if ($('#txtMasterCountry').val() !== '') okFields.push($('#txtMasterCountry')); else errorFields.push($('#txtMasterCountry'));
                    if ($('#txtMasterAverage').val() !== '' && $('#txtMasterAverage').val() >= 0 && $('#txtMasterAverage').val() <= 100) okFields.push($('#txtMasterAverage')); else errorFields.push($('#txtMasterAverage'));
                }
                else {
                    okFields.push($('#txtMasterField'));
                    okFields.push($('#txtMasterUniversity'));
                    okFields.push($('#txtMasterCountry'));
                    okFields.push($('#txtMasterAverage'));
                }
                if (phd == 1) {
                    if ($('#txtDoctorateField').val() !== '') okFields.push($('#txtDoctorateField')); else errorFields.push($('#txtDoctorateField'));
                    if ($('#txtDoctorateUniversity').val() !== '') okFields.push($('#txtDoctorateUniversity')); else errorFields.push($('#txtDoctorateUniversity'));
                    if ($('#txtDoctorateCountry').val() !== '') okFields.push($('#txtDoctorateCountry')); else errorFields.push($('#txtDoctorateCountry'));
                    if ($('#txtDoctorateAverage').val() !== '' && $('#txtDoctorateAverage').val() >= 0 && $('#txtDoctorateAverage').val() <= 100) okFields.push($('#txtDoctorateAverage')); else errorFields.push($('#txtDoctorateAverage'));
                }
                else {
                    okFields.push($('#txtDoctorateField'));
                    okFields.push($('#txtDoctorateUniversity'));
                    okFields.push($('#txtDoctorateCountry'));
                    okFields.push($('#txtDoctorateAverage'));
                }

                break;
            case 5:
                var cf = false;
                $('#tblChosenFields > tbody > tr').each(function (i, e) {
                    if ($(e).find('td:nth-child(2)').html() !== '') cf = true;
                });
                if (cf) okFields.push($('#tblChosenFields')); else errorFields.push($('#tblChosenFields'));
                break;
            default:
                break;
        }

        $.each(errorFields, function (index, el) {
            el.css({ border: '1px solid rgb(255, 85, 85)', boxShadow: 'rgb(255, 85, 85) 0px 0px 10px 0px' });
        });
        $.each(okFields, function (index, el) {
            el.css({ border: '1px solid #ced4da', boxShadow: 'none' });
        });
        if (errorFields.length == 0)
            return true;
        else {
            //alert($(errorFields[0]).val());
            return false;
        }
    }

    function isValidDate(dateString) {
        // First check for the pattern
        if (!/^\d{4}\/\d{1,2}\/\d{1,2}$/.test(dateString))
            return false;

        // Parse the date parts to integers
        var parts = dateString.split("/");
        var day = parseInt(parts[2], 10);
        var month = parseInt(parts[1], 10);
        var year = parseInt(parts[0], 10);

        // Check the ranges of month and year
        if (year < 1000 || year > 3000 || month == 0 || month > 12)
            return false;

        var monthLength = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        // Adjust for leap years
        if (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
            monthLength[1] = 29;

        // Check the range of the day
        return day > 0 && day <= monthLength[month - 1];
    };
    //-- Validate Form Inputs End



    //-- Login Post Start
    $('#txtLoginUsername, #txtLoginPassword').keypress(function (e) {
        var key = e.which;
        if (key == 13)
            $('#btnLogin').click();
    });

    $('#btnLogin').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        el.prop('disabled', true);
        $('#loginLoading').show();
        $.ajax({
            url: '/' + el.data('lang') + '/Account/Login',
            type: 'POST',
            data: { username: $('#txtLoginUsername').val(), password: $('#txtLoginPassword').val() },
            success: function (result) {
                if (result.LoginResult)
                    window.location = '/' + el.data('lang') + '/Request'
                else {
                    $('.loginError').html(result.Message);
                    $('.loginError').show();
                }
                $('#loginLoading').hide();
                el.prop('disabled', false);
            }
        });
    });
    //-- Login Post End

    //-- Signup Post Start
    $('#txtSignupEmail, #txtSignupFirstName, #txtSignupLastName, #ddlLanguage, #txtSignupMobile, #txtSignupPassword, #txtSignupPasswordRepeat, #CountryList').keypress(function (e) {
        var key = e.which;
        if (key == 13)
            $('#btnSignup').click();
    });


    $('#btnSignup').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        var emailaddress = $('#txtSignupEmail').val();
        if (emailaddress != '' && !emailReg.test(emailaddress)) { $('#txtSignupEmail').css({ border: '1px solid red', boxShadow: 'rgb(255, 85, 85) 0px 0px 10px 0px' }); return; }
        else $('#txtSignupEmail').css({ border: '1px solid #ced4da', boxShadow: 'none' });
        el.prop('disabled', true);
        $('#signupLoading').show();
        $.ajax({
            url: '/' + el.data('lang') + '/Account/Signup',
            type: 'POST',
            data: {
                firstName: $('#txtSignupFirstName').val()
                , lastName: $('#txtSignupLastName').val()
                , language: $('#ddlLanguage').val()
                , mobile: $('#txtSignupMobile').val()
                , email: $('#txtSignupEmail').val()
                , password: $('#txtSignupPassword').val()
                , repeatPass: $('#txtSignupPasswordRepeat').val()
                , citizenship: $('#CountryList').val()
            },
            success: function (result) {
                if (result.LoginResult) {
                    $('.signupError').hide();
                    $('.signupInfo').hide();
                    $('.signupSuccess').html(result.Message);
                    $('.signupSuccess').show();
                }
                else {
                    $('.signupError').html(result.Message);
                    $('.signupError').show();
                }
                el.prop('disabled', false);
                $('#signupLoading').hide();
            }
        });
    });
    //-- Signup Post End

    //-- Signout Post Start
    $('.btnSignout').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        $.ajax({
            url: '/' + el.data('lang') + '/Account/Signout',
            type: 'POST',
            data: {},
            success: function (result) {
                window.location = result.NewURL;
            }
        });
    });
    //-- Signout Post End

    //-- PasswordRecovery Post Start
    $('#btnPasswordRecovery').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        $.ajax({
            url: '/' + el.data('lang') + '/Account/PasswordRecoveryRequest',
            type: 'POST',
            data: { email: $('#txtPassordRecoveryEmail').val() },
            success: function (result) {
                if (result.Result) {
                    $('.passwordRecoveryMessage').removeClass('alert-danger');
                    $('.passwordRecoveryMessage').addClass('alert-success');
                    $('.passwordRecoveryMessage').html(result.Message);
                    $('#btnPasswordRecovery').hide();
                    $('#txtPassordRecoveryEmail').hide();
                }
                else {
                    $('.passwordRecoveryMessage').removeClass('alert-success');
                    $('.passwordRecoveryMessage').addClass('alert-danger');
                    $('.passwordRecoveryMessage').html(result.Message);
                }
            }
        });
    });
    //-- PasswordRecovery Post End

    //-- PasswordReset Post Start
    $('#btnResetPassword').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        $.ajax({
            url: '/' + el.data('lang') + '/Account/PasswordResetRequest',
            type: 'POST',
            data: { password: $('#pwdNewPassword').val(), passwordRepeat: $('#pwdNewPasswordRepeat').val() },
            success: function (result) {
                if (result.Result) {
                    $('#passwordResetMessage').addClass('alert-success');
                    $('#passwordResetMessage').html(result.Message);
                    $('#btnResetPassword').hide();
                    $('#pwdNewPassword').hide();
                    $('#pwdNewPasswordRepeat').hide();
                    setTimeout(function () { window.location = '/' + el.data('lang') + '/Request' }, 3000);
                }
                else if (result.Message !== '') {
                    $('#passwordResetMessage').addClass('alert-danger');
                    $('#passwordResetMessage').html(result.Message);
                }
                else {
                    window.location = '/' + el.data('lang');
                }
            }
        });
    });
    //-- PasswordReset Post End

    ///---- Requests Tabs Start
    $('.next-tab, .prev-tab').click(function (e) {
        e.preventDefault();
        if ($(this).hasClass('next-tab')) {
            $('.saveFormContent').click();
            if (!ValidateTab($(this).attr("rel") - 1))
                return false;
        }
        $('#tabs').tabs('option', 'disabled', []);
        if (editMode) {
            editMode = false;
            $('.prev-tab').show();
            CreatePreview();
            $('#tabs').tabs('option', 'active', 6);
        }
        else
            $('#tabs').tabs('option', 'active', $(this).attr('rel'));
        $("html, body").animate({ scrollTop: 0 }, 500, 'swing');
        return false;
    });

    $('#btnSubmitFields').on('click', function (e) {
        e.preventDefault();
        CreatePreview();
    });

    $('#btnForgetPassword').on('click', function (e) {
        e.preventDefault();
        window.location = '/' + $(this).data('lang') + '/Account/PasswordRecovery';
    });

    function CreatePreview() {
        $('#prFirstName').text($('#txtFirstName').val());
        $('#prvMiddlename').text($('#txtMiddleName').val());
        $('#prvLastname').text($('#txtLastName').val());
        $('#prvFathersName').text($('#txtFatherName').val());
        $('#prvMothersName').text($('#txtMotherName').val());
        $('#prvGrandFathersName').text($('#txtGrandFatherName').val());
        $('#prvBirthDate').text($('#txtBirthDate').val());
        $('#prvBirthPlace').text($('#txtBirthPlace').val());
        $('#prvGender').text($('#ddlGender option:selected').text());
        $('#prvMaritalStatus').text($('#ddlMarriage option:selected').text());
        $('#prvChildren').text($('#txtChildren').val());
        $('#prvPhysicalStatus').text($('#ddlPhysicalStatus option:selected').text());
        $('#prvRelegion').text($('#ddlRelegion option:selected').text());

        $('#prvCitizenship').text($('#ddlCitizen option:selected').text());
        $('#prvDocNumber').text($('#txtPassNo').val());
        $('#prvSecondCitizenship').text($('#ddlSecondCitizen option:selected').text());

        $('#prvIranResidenceCity').text($('#txtIranHomeCity').val());
        $('#prvIranResidencePhoneNumber').text('+' + $('#ddlIranHomePhoneCode').val() + ' ' + $('#txtIranHomePhone').val());
        $('#prvIranResidenceMobile').text('+' + $('#ddlIranMobileCode').val() + ' ' + $('#txtMobile').val());
        $('#prvIranResidencePlaceNumber').text($('#txtIranHomePlaque').val());
        $('#prvIranResidencePostalCode').text($('#txtIranHomePostalCode').val());
        $('#prvIranResidenceState').text($('#txtIranHomeState').val());
        $('#prvIranResidenceStreet').text($('#txtIranHomeStreet').val());
        $('#prvIranResidenceEmail').text($('#txtEmail').val());
        $('#prvIranWorkPlaceState').text($('#txtIranWorkState').val());
        $('#prvIranWorkPlacePhoneNumber').text('+' + $('#ddlIranWorkPhone').val() + ' ' + $('#txtIranWorkPhone').val());
        $('#prvIranWorkPlacePlaceNumber').text($('#txtIranWorkPlaque').val());
        $('#prvIranWorkPlacePostalCode').text($('#txtIranWorkPostalCode').val());
        $('#prvIranWorkPlaceCity').text($('#txtIranWorkCity').val());
        $('#prvIranWorkPlaceStreet').text($('#txtIranWorkStreet').val());
        $('#prvCitizenshipResidencCity').text($('#txtCitizenHomeCity').val());
        $('#prvCitizenshipResidencPhoneNumber').text('+' + $('#ddlCitizenHomePhoneCode').val() + ' ' + $('#txtCitizenHomePhone').val());
        $('#prvCitizenshipResidencMobile').text('+' + $('#ddlCitizenMobileCode').val() + ' ' + $('#txtCitizenMobile').val());
        $('#prvCitizenshipResidencPlaceNumber').text($('#txtCitizenHomePlaque').val());
        $('#prvCitizenshipResidencPostalCode').text($('#txtCitizenHomePostalCode').val());
        $('#prvCitizenshipResidencState').text($('#txtCitizenHomeState').val());
        $('#prvCitizenshipResidencStreet').text($('#txtCitizenHomeStreet').val());
        $('#prvCitizenshipResidencEmail').text($('#txtCitizenEmail').val());
        $('#prvCitizenshipWorkPlaceState').text($('#txtCitizenWorkState').val());
        $('#prvCitizenshipWorkPlacePhoneNumber').text('+' + $('#ddlCitizenWorkPhoneCode').val() + ' ' + $('#txtCitizenWorkPhone').val());
        $('#prvCitizenshipWorkPlacePlaceNumber').text($('#txtCitizenWorkPlaque').val());
        $('#prvCitizenshipWorkPlacePostalCode').text($('#txtCitizenWorkPostalCode').val());
        $('#prvCitizenshipWorkPlaceCity').text($('#txtCitizenWorkCity').val());
        $('#prvCitizenshipWorkPlaceStreet').text($('#txtCitizenWorkStreet').val());

        if ($('#txtIranHomeCity').val() === '') $('#prvIranResidenceAddress').hide(); else $('#prvIranResidenceAddress').show();
        if ($('#txtIranWorkCity').val() === '') $('#prvIranWorkPlace').hide(); else $('#prvIranWorkPlace').show();
        if ($('#txtCitizenHomeCity').val() === '') $('#prvCitizenshipResidenceAddress').hide(); else $('#prvCitizenshipResidenceAddress').show();
        if ($('#txtCitizenWorkCity').val() === '') $('#prvCitizenshipWorkPlaceAddress').hide(); else $('#prvCitizenshipWorkPlaceAddress').show();

        if ($('#txtMothersFirstName').val() !== '') {
            $('#prvMotherFieldset').show();
            $('#prvMotherFirstName').text($('#txtMothersFirstName').val());
            $('#prvMotherLastName').text($('#txtMothersLastName').val());
            $('#prvMotherFathersName').text($('#txtMothersFathersName').val());
            $('#prvMotherGrandFathersName').text($('#txtMothersGrandFathersName').val());
            $('#prvMotherBirthDate').text($('#txtMothersBirthDate').val());
            $('#prvMotherBirthPlace').text($('#txtMothersBirthPlace').val());
            $('#prvMotherIdNumber').text($('#txtMothersIdNumber').val());
            $('#prvMotherIssuePlace').text($('#txtMothersIssuePlace').val());
            $('#prvMotherNationalCode').text($('#txtMothersNationalCode').val());
            $('#prvMotherMarriageType').text($('#txtMothersMarriageType option:selected').text());
        }
        else
            $('#prvMotherFieldset').hide();

        if ($('#txtRecommenderFirstname').val() !== '') {
            $('#prvRecommenderFieldset').show();
            $('#prvRecommenderRelationship').text($('#ddlRecommenderRelationship option:selected').text());
            $('#prvRecommenderFirstname').text($('#txtRecommenderFirstname').val());
            $('#prvRecommenderLastname').text($('#txtRecommenderLastname').val());
            $('#prvRecommenderFathersName').text($('#txtRecommenderFathersName').val());
            $('#prvRecommenderGrandFathersName').text($('#txtRecommenderGrandFathersName').val());
            $('#prvRecommenderBirthDate').text($('#txtRecommenderBirthDate').val());
            $('#prvRecommenderDocumentType').text($('#ddlRecommenderDocumentType option:selected').text());
            $('#prvRecommenderDocumentNumber').text($('#txtRecommenderDocumentNumber').val());
            $('#prvRecommenderJob').text($('#txtRecommenderJobTitle').val());
            $('#prvRecommenderCitizenship').text($('#txtRecommenderCitizenship option:selected').text());
            $('#prvRecommenderMobile').text($('#ddlRecommenderMobileCode option:selected').text() + ' ' + $('#txtRecommenderMobile').val());
            $('#prvRecommenderCode').text($('#txtRecommenderCode').val());
        }
        else
            $('#prvRecommenderFieldset').hide();

        var hasFamilyMember = 0;
        var prvFamilyTable = $('#familyPersonsPrv > tbody');
        prvFamilyTable.html('');
        $('#familyPersonsTable > tbody > tr').each(function (i, e) {
            if ($(e).find('td:nth-child(1) > select').val() !== '') {
                hasFamilyMember = 1;
                var tr = "<tr class=\"form-group\">";
                tr += "<td><span>" + $(e).find('td:nth-child(1) > select option:selected').text() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(2) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(3) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(4) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(5) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(6) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(7) > select option:selected').text() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(8) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(9) > input').val() + "</span></td>";
                tr += "<td><span>" + $(e).find('td:nth-child(10) > select option:selected').text() + "</span></td>";
                tr += "</tr>";
                prvFamilyTable.append(tr);
            }
        });
        if (hasFamilyMember > 0)
            $('#prvFamilyFieldset').show();
        else
            $('#prvFamilyFieldset').hide();


        if ($('#txtDiplomaWrittenAverage').val() !== '' || $('#txtDiplomaPlace').val() !== '' || $('#txtDiplomaField').val() !== '' || $('#txtDiplomaTotalAverage').val() !== '') {
            $('#prvDiplomaFieldset').show();
            $('#prvDiplomaWrittenAverage').text($('#txtDiplomaWrittenAverage').val());
            $('#prvDiplomaDegreePlace').text($('#txtDiplomaPlace').val());
            $('#prvDiplomaFieldOfStudy').text($('#txtDiplomaField').val());
            $('#prvDiplomaTotalAverage').text($('#txtDiplomaTotalAverage').val());
        }
        else
            $('#prvDiplomaFieldset').hide();
        if ($('#txtPreUniversityAverage').val() !== '' || $('#txtPreuniversityField').val() !== '') {
            $('#prvPreUniversityFieldset').show();
            $('#prvPreUniversityAverage').text($('#txtPreUniversityAverage').val());
            $('#prvPreUniversityField').text($('#txtPreuniversityField').val());

        }
        else
            $('#prvPreUniversityFieldset').hide();
        if ($('#txtBachelorField').val() !== '' || $('#txtBachelorUniversity').val() !== '' || $('#txtBachelorCountry').val() !== '' || $('#txtBachelorAverage').val() !== '') {
            $('#prvBachelorFieldset').show();
            $('#prvBachelorFieldOfStudy').text($('#txtBachelorField').val());
            $('#prvBachelorUniversityName').text($('#txtBachelorUniversity').val());
            $('#prvBachelorCountryOfStudy').text($('#txtBachelorCountry').val());
            $('#prvBachelorAverage').text($('#txtBachelorAverage').val());
        }
        else
            $('#prvBachelorFieldset').hide();
        if ($('#txtMasterField').val() !== '' || $('#txtMasterUniversity').val() !== '' || $('#txtMasterCountry').val() !== '' || $('#txtMasterAverage').val() !== '') {
            $('#prvMasterFieldset').show();
            $('#prvMasterFieldOfStudy').text($('#txtMasterField').val());
            $('#prvMasterUniversityName').text($('#txtMasterUniversity').val());
            $('#prvMasterCountryOfStudy').text($('#txtMasterCountry').val());
            $('#prvMasterAverage').text($('#txtMasterAverage').val());
        }
        else
            $('#prvMasterFieldset').hide();
        if ($('#txtDoctorateField').val() !== '' || $('#txtDoctorateUniversity').val() !== '' || $('#txtDoctorateCountry').val() !== '' || $('#txtDoctorateAverage').val() !== '') {
            $('#prvPhdFieldset').show();
            $('#prvPhdFieldOfStudy').text($('#txtDoctorateField').val());
            $('#prvPhdUniversityName').text($('#txtDoctorateUniversity').val());
            $('#prvPhdCountryOfStudy').text($('#txtDoctorateCountry').val());
            $('#prvPhdAverage').text($('#txtDoctorateAverage').val());
        }
        else
            $('#prvPhdFieldset').hide();

        $('#prvChosenFields > tbody').html('');
        $('#tblChosenFields > tbody > tr').each(function (i, e) {
            if ($(e).find('td:nth-child(2)').text() !== '') {
                var tr = '<tr>';
                tr += '<td>' + $(e).find('td:nth-child(1)').text() + '</td>';
                tr += '<td>' + $(e).find('td:nth-child(2)').text() + '</td>';
                tr += '<td>' + $(e).find('td:nth-child(3)').text() + '</td>';
                tr += '<td>' + $(e).find('td:nth-child(4)').text() + '</td>';
                tr += '</tr>';
                $('#prvChosenFields > tbody').append(tr);
            }
        });



    }

    $('#btnConfirmInfo').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        var condidateFields = [];
        var relatedPersons = [];
        $('#tblChosenFields > tbody > tr').each(function (i, e) {
            if ($(e).find('td:nth-child(2)').html() !== '')
                condidateFields.push($(e).find('td:nth-child(2)').html());
        });
        $('#familyPersonsTable > tbody > tr').each(function (i, e) {
            if ($(e).find('td:nth-child(1) input').val() !== '') {
                relatedPersons.push({
                    Relationship: $(e).find('td:nth-child(1) select').val()
                    , FirstName: $(e).find('td:nth-child(2) input').val()
                    , LastName: $(e).find('td:nth-child(3) input').val()
                    , FathersName: $(e).find('td:nth-child(4) input').val()
                    , GrandFathersName: $(e).find('td:nth-child(5) input').val()
                    , BirthDate: $(e).find('td:nth-child(6) input').val()
                    , DocType: $(e).find('td:nth-child(7) select').val()
                    , DocNo: $(e).find('td:nth-child(8) input').val()
                    , Job: $(e).find('td:nth-child(9) input').val()
                    , Citizenship: $(e).find('td:nth-child(10) select').val()
                });
            }
        });



        var data = {
            userId: $('#userId').val()
            , FirstName: $('#txtFirstName').val()
            , MiddleName: $('#txtMiddleName').val()
            , LastName: $('#txtLastName').val()
            , FatherName: $('#txtFatherName').val()
            , MotherName: $('#txtMotherName').val()
            , GrandFatherName: $('#txtGrandFatherName').val()
            , BirthDate: $('#txtBirthDate').val()
            , BirthPlace: $('#txtBirthPlace').val()
            , Gender: $('#ddlGender').val()
            , MarritalType: $('#ddlMarriage').val()
            , ChildrenCount: $('#txtChildren').val()
            , HealthStatus: $('#ddlPhysicalStatus').val()
            , Religion: $('#ddlRelegion').val()

            , FirstCountryId: $('#ddlCitizen').val()
            , DocNo: $('#txtPassNo').val()
            , SecondCountryId: $('#ddlSecondCitizen').val()
            /*------------------------------------*/
            , IranHomeCity: $('#txtIranHomeCity').val()
            , IranHomePhone: $('#txtIranHomePhone').val()
            , IranHomeNumber: $('#txtIranHomePlaque').val()
            , IranHomePostalCode: $('#txtIranHomePostalCode').val()
            , IranHomeState: $('#txtIranHomeState').val()
            , IranHomeStreet: $('#txtIranHomeStreet').val()
            , IranHomeMobile: $('#txtMobile').val()
            , IranHomeEmail: $('#txtEmail').val()
            , IranHomeMobileCode: $('#ddlIranMobileCode').val()
            , IranHomePhoneCode: $('#ddlIranHomePhoneCode').val()

            , IranWorkCity: $('#txtIranWorkCity').val()
            , IranWorkPhone: $('#txtIranWorkPhone').val()
            , IranWorkNumber: $('#txtIranWorkPlaque').val()
            , IranWorkPostalCode: $('#txtIranWorkPostalCode').val()
            , IranWorkState: $('#txtIranWorkState').val()
            , IranWorkStreet: $('#txtIranWorkStreet').val()

            , CitizenshipHomeCity: $('#txtCitizenHomeCity').val()
            , CitizenshipHomePhone: $('#txtCitizenHomePhone').val()
            , CitizenshipHomeNumber: $('#txtCitizenHomePlaque').val()
            , CitizenshipHomePostalCode: $('#txtCitizenHomePostalCode').val()
            , CitizenshipHomeState: $('#txtCitizenHomeState').val()
            , CitizenshipHomeStreet: $('#txtCitizenHomeStreet').val()
            , CitizenshipHomeEmail: $('#txtCitizenEmail').val()
            , CitizenshipHomeMobile: $('#txtCitizenMobile').val()
            , CitizenshipHomeMobileCode: $('#ddlCitizenMobileCode').val()
            , CitizenshipHomePhoneCode: $('#ddlCitizenHomePhoneCode').val()

            , CitizenshipWorkCity: $('#txtCitizenWorkCity').val()
            , CitizenshipWorkPhone: $('#txtCitizenWorkPhone').val()
            , CitizenshipWorkNumber: $('#txtCitizenWorkPlaque').val()
            , CitizenshipWorkPostalCode: $('#txtCitizenWorkPostalCode').val()
            , CitizenshipWorkState: $('#txtCitizenWorkState').val()
            , CitizenshipWorkStreet: $('#txtCitizenWorkStreet').val()
            /*------------------------------------*/

            , MothersBirthDate: $('#txtMothersBirthDate').val()
            , MothersBirthPlace: $('#txtMothersBirthPlace').val()
            , MothersFatherName: $('#txtMothersFathersName').val()
            , MothersFirstName: $('#txtMothersFirstName').val()
            , MothersGrandFatherName: $('#txtMothersGrandFathersName').val()
            , MothersIdNo: $('#txtMothersIdNumber').val()
            , MothersIssuePlace: $('#txtMothersIssuePlace').val()
            , MothersLastName: $('#txtMothersLastName').val()
            , MothersNationalCode: $('#txtMothersNationalCode').val()
            , MothersMarritalType: $('#txtMothersMarriageType').val()

            /*------------------------------------*/
            , RecommenderDocType: $('#ddlRecommenderDocumentType').val()
            , RecommenderCountryId: $('#txtRecommenderCitizenship').val()
            , RecommenderDocNo: $('#txtRecommenderDocumentNumber').val()
            , RecommenderBirthDate: $('#txtRecommenderBirthDate').val()
            , RecommenderFatherName: $('#txtRecommenderFathersName').val()
            , RecommenderFirstName: $('#txtRecommenderFirstname').val()
            , RecommenderGrandFatherName: $('#txtRecommenderGrandFathersName').val()
            , RecommenderLastName: $('#txtRecommenderLastname').val()
            , RecommenderJob: $('#txtRecommenderJobTitle').val()
            , RecommenderRelationship: $('#ddlRecommenderRelationship').val()
            , RecommenderMobile: $('#txtRecommenderMobile').val()
            , RecommenderMobileCode: $('#ddlRecommenderMobileCode').val()

            , RecommenderCode: $('#txtRecommenderCode').val()
            /*------------------------------------*/

            , DiplomaEducationDegreePlace: $('#txtDiplomaPlace').val()
            //, DiplomaFieldId: $('#ddlDiplomaField').val()
            , DiplomaFieldTitle: $('#txtDiplomaField').val()
            , DiplomaTotalAverage: $('#txtDiplomaTotalAverage').val()
            , DiplomaWrittenAverage: $('#txtDiplomaWrittenAverage').val()

            , PreuniversityTotalAverage: $('#txtPreUniversityAverage').val()
            //, PreuniversityFieldId: $('#ddlPreuniversityField').val()
            , PreuniversityFieldTitle: $('#txtPreuniversityField').val()

            //, BachelorFieldId: $('#ddlBachelorField').val()
            , BachelorFieldTitle: $('#txtBachelorField').val()
            , BachelorCountryName: $('#txtBachelorCountry').val()
            , BachelorUniversityName: $('#txtBachelorUniversity').val()
            , BachelorTotalAverage: $('#txtBachelorAverage').val()
            //, MAFieldId: $('#ddlMasterField').val()
            , MAFieldTitle: $('#txtMasterField').val()
            , MACountryName: $('#txtMasterCountry').val()
            , MAUniversityName: $('#txtMasterUniversity').val()
            , MATotalAverage: $('#txtMasterAverage').val()
            //, DoctorateFieldId: $('#ddlDoctorateField').val()
            , DoctorateFieldTitle: $('#txtDoctorateField').val()
            , DoctorateCountryName: $('#txtDoctorateCountry').val()
            , DoctorateUniversityName: $('#txtDoctorateUniversity').val()
            , DoctorateTotalAverage: $('#txtDoctorateAverage').val()
            , RequestedLevel: $('#ddlLevel').val() 
            , CondidateFields: condidateFields
            , RelatedPersons: relatedPersons
        };
        $.ajax({
            url: '/' + el.data('lang') + '/Request/AddNewStudentRequest',
            type: 'POST',
            data: { 'data': JSON.stringify(data) },
            success: function (result) {
                if (result.Result)
                    window.location = '/' + el.data('lang') + '/Documents/UploadDocuments';
                else
                    alert(result.Message);
            }
        });
    });


    $('#btnSearchFields').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        $.ajax({
            url: '/' + el.data('lang') + '/Request/SearchField',
            type: 'POST',
            data: { 'levelId': $('#ddlLevel').val(), 'collegeId': $('#ddlCollege').val(), 'searchText': $('#txtField').val() },
            success: function (result) {
                $('#tblFields > tbody').html('');
                if (result.Message === '') {
                    //$('#tblFields').html('<tbody>');
                    var tr = '';
                    var json = $.parseJSON(result.Result);
                    $.each(json, function (index, data) {
                        $.each(data, function (key, data) {
                            if (key == 'Id')
                                tr += '<tr><td>' + data + '</td>';
                            else if (key == 'Field_Name')
                                tr += '<td>' + data + '</td>';
                            else if (key == 'FieldLevel')
                                tr += '<td>' + data + '</td>';
                            else if (key == 'CollegeName')
                                tr += '<td><input type="hidden" id="hdnCollege" value="' + data + '" /> <input type="button" value="+" class="btn btn-info btnChooseField" /></td></tr>';
                        });
                    });
                    //$('#tblFields').html($('#tblFields').html() + tr + '</tbody>');
                    $('#tblFields > tbody').append(tr);
                }
                else
                    alert(result.Message);
            }
        });
    });

    $('#ddlLevel').on('change', function () {
        $.ajax({
            url: '/' + $('#ddlLevel').data('lang') + '/Request/GetCollegesByLevel',
            type: 'POST',
            data: { 'data': $('#ddlLevel').val() },
            success: function (result) {
                $('#ddlCollege').html(result.HTML);
            }
        });
    });

    var ChosenFields = [];

    $(document).on('click', '.btnChooseField', function (e) {
        e.preventDefault();
        if ($.inArray($(this).parent().parent().find('td:first-child').html(), ChosenFields) < 0 && ChosenFields.length < 30) {
            $('#tblChosenFields > tbody > tr').each(function (i, e) {
                if ($(e).find('td:nth-child(2)').html() === '')
                    $(e).remove();
            });
            var tr = '<tr><td>' + $(this).parent().parent().find('td:first-child').html() + '</td>';
            tr += '<td>' + $(this).parent().find('#hdnCollege').val() + '</td>';
            tr += '<td>' + $(this).parent().parent().find('td:nth-child(2)').html() + '</td>';
            tr += '<td><input type="button" value ="x" class="btn btn-danger btnRemoveField" /></td></tr>';
            $('#tblChosenFields > tbody').html($('#tblChosenFields > tbody').html() + tr);
            var rowCount = $('#tblChosenFields > tbody > tr').length;
            for (i = 0; i + rowCount < 30; i++)
                $('#tblChosenFields > tbody').append('<tr><td></td><td></td><td></td><td></td><td></td></tr>')
            $('#tblChosenFields > tbody > tr').each(function (i, e) {
                if ($(e).find('td').length == 5)
                    $(e).find('td:first-child').remove();
                $(e).prepend('<td>' + (i + 1) + '</td>');
            });
            ChosenFields.push($(this).parent().parent().find('td:first-child').html());
        }
    });

    $(document).on('click', '.btnRemoveField', function (e) {
        e.preventDefault();
        ChosenFields.splice($.inArray($(this).parent().parent().find('td:nth-child(2)').html(), ChosenFields), 1);
        $(this).parent().parent().remove();
        var rowCount = $('#tblChosenFields > tbody > tr').length;
        for (i = 0; i + rowCount < 30; i++)
            $('#tblChosenFields > tbody').append('<tr><td></td><td></td><td></td><td></td><td></td></tr>')
        $('#tblChosenFields > tbody > tr').each(function (i, e) {
            if ($(e).find('td').length == 5)
                $(e).find('td:first-child').remove();
            $(e).prepend('<td>' + (i + 1) + '</td>');
        });
    });

    $(document).on('click', '.btnEditInfo', function (e) {
        e.preventDefault();
        var el = $(this);
        editMode = true;
        $('.prev-tab').hide();
        $('#tabs').tabs('option', 'disabled', []);
        $('#tabs').tabs('option', 'active', el.data('tabid'));
        $("html, body").animate({ scrollTop: 0 }, 500, 'swing');
    });

    ///---- Requests Tabs End
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 


    //https://blog.eduonix.com/web-programming-tutorials/learn-to-upload-a-file-in-mvc-via-ajax/
    //http://lateshtclick.com/blogpost/upload-fileimage-and-other-data-using-jquery-ajax-call-in-mvc
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    //select multiple image and send them to server
    $('#frmReUploadDocument').submit(function (e) {
        e.preventDefault(); // stop the standard form submission

        var fileUploader = $("#fileUploader");
        var files = fileUploader.get(0).files;
        var formdata = new FormData();
        formdata.append("hdn_reqid", $("#hdn_reqid").val());
        formdata.append("hdn_doc_id", $("#hdn_doc_id").val());
        formdata.append("hdn_detector", $("#hdn_detector").val());
        if (fileUploader != null && files.length > 0) {
            //for (i = 0; i < files.length; i++) {
            //Appending each file to FormData object
            //formdata.append(files[i].name, files[i]);
            //}
            //for an input file without multiple property
            formdata.append(files[0].name, files[0]);
            $.ajax({
                url: this.action,
                type: this.method,
                data: formdata,//new FormData(this),
                cache: false,
                contentType: false,
                processData: false,
                success: function (data) {
                    //window.location.replace(window.location.href);
                    window.location.href = window.location.href;
                    //if (data.Result) {
                    //alert(data.Messege + ' file(s) uploaded successfully');
                    //window.location.reload();
                    //}                    
                },
                error: function (xhr, error, status) {
                    alert(error, status);
                }
            });
        }
    });


    $("button[name='btnFileLoader']").on("click", function (e) {
        var reqId = $(this).data("reqid");
        var docId = $(this).data("docid");
        var detector = $(this).data("detector");

        $("#hdn_reqid").val(reqId);
        $("#hdn_doc_id").val(docId);
        $("#hdn_detector").val(detector);
    });

    function checkFileValidation(fileInput) {        
        var fileName = fileInput.files[0].name.trim();
        var fileSize = fileInput.files[0].size;
        var res = true;
        var regex = /\.(jpg|jpeg)$/i;
        if (!regex.test(fileName)) {
            //alert("File type only must be jpg ,jpeg  ", "Invalid Image Type ");
            fileInput.value = "";
            $("#imgUploader").attr("src", "");
            $("#imgUploader").hide();
            return false;
            if (fileSize > 500000) { //0.5 mb
                //alert("Size of ", "Invalid Image Type ");
                fileInput.value = "";
                $("#imgUploader").attr("src", "");
                $("#imgUploader").hide();
                return false;
            }
        }
        return res;
    }


    $("#fileUploader").on("change", function (e) {
        debugger;
        if (!checkFileValidation(this)) return false;
        var imgUploader = $("#imgUploader");
        imgUploader.show();
        imgUploader.attr("src", URL.createObjectURL(e.target.files[0]));        
    });


    $('#uploadModal').on('hidden.bs.modal', function () {
        $("#fileUploader").val("");
        $("#imgUploader").attr("src", "");
        $("#imgUploader").hide();
    })


    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    $("#dialog-confirm").hide();
    ///---- Management End


    $('#ddlSelectLang').val($('#hdnCulture').val());
    $('#ddlSelectLang').on('change', function () {
        $.ajax({
            url: '/fa/Account/ChangeLanguage',
            type: 'POST',
            data: { 'lang': $('#ddlSelectLang').val(), 'currentUrl': window.location.pathname },
            success: function (result) {
                window.location = result.NewURL;
            }
        });
    });

    $('.btnRequestDetails').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        window.location = '/' + el.data('lang') + '/Request/ShowDetails/' + el.attr('data-reqId');//.data('reqId');
    });


    $('.btnRequestDetailsPrintable').on('click', function (e) {
        e.preventDefault();
        var el = $(this);
        window.location = '/' + el.data('lang') + '/Request/PrintInfo/' + el.attr('data-reqId');//.data('reqId');
    });

    $('#btnPrintInfo').on('click', function (e) {
        var switchDirection = "ltr";
        if ($(this).data("lang") !== "en")
            switchDirection = "rtl";
        var content = $("#printWrapper").html();
        var width = 800;
        var height = 800;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        var params = 'width=' + width + ', height=' + height;
        params += ', top=' + top + ', left=' + left;
        params += ', directories=no';
        params += ', location=no';
        params += ', menubar=no';
        params += ', resizable=no';
        params += ', scrollbars=no';
        params += ', status=no';
        params += ', toolbar=no';
        var win = window.open('', '_blank', params);
        var pageTitle = "";
        var noCashCss = Math.floor(Date.now() / 1000);

        //http://localhost:2145/fa/Request/PrintInfo/6
        win.document.write('<html><head><title>' + pageTitle + '</title>');
        win.document.write('<link rel="stylesheet" href="../../../../Content/bootstrap.min.css" type="text/css" />');
        win.document.write('<link rel="stylesheet" href="../../../../Content/printinfo.css?n=' + noCashCss + '" type="text/css" />');
        win.document.write('</head><body class=\"' + switchDirection + '\">');
        win.document.write(content);
        win.document.write('</body></html>');
        setTimeout(function () {
            win.print();
            win.close();
        }, 500);
    });

    $("#btnComeBack").on("click", function (e) {
        history.back();
    });

});

$(window).on('resize', function () {
    if ($(window).width() >= 768) {
        $('#contentHeight, #tabs').css('minHeight', ($(window).height() - $('.headerBox').height() - $('.footerBox').height()) + 'px');
    }
});