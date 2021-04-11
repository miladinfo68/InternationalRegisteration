using ISR.Commons.enums;
namespace ISR.Commons
{
    public static class EnumsPersianTitles
    {
        public static string GetMaretalStatus(byte? maratal)
        {
            var res = "";
            switch (maratal)
            {
                case ((byte)MarritalStatus.Married): res = Resources.Resources.Married; break;
                case ((byte)MarritalStatus.Married_Away): res = Resources.Resources.Married_Away; break;
                case ((byte)MarritalStatus.Single): res = Resources.Resources.Single; break;
                case ((byte)MarritalStatus.Widow): res = Resources.Resources.Widow; break;
                case ((byte)MarritalStatus.Separated): res = Resources.Resources.Separated; break;
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;
            }
            return res;
        }
        //#####################################################
        public static string GetMaretalType(byte? maratal)
        {
            var res = "";
            switch (maratal)
            {
                case ((byte)MarritalType.Official): res = Resources.Resources.Official; break;
                case ((byte)MarritalType.Unofficial): res = Resources.Resources.Unofficial; break;
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;
            }
            return res;
        }
        //#####################################################
        public static string GetHealthStatus(byte? health)
        {
            var res = "";
            switch (health)
            {
                case ((byte)HealthStatus.Veteran): res = Resources.Resources.Veteran; break;
                case ((byte)HealthStatus.OtherDisabilities): res = Resources.Resources.OtherDisabilities; break;
                case ((byte)HealthStatus.CompleteHealth): res = Resources.Resources.CompleteHealth; break;
                case ((byte)HealthStatus.DisabilityOfHearing): res = Resources.Resources.DisabilityOfHearing; break;
                case ((byte)HealthStatus.DisabilityOfMovement): res = Resources.Resources.DisabilityOfMovement; break;
                case ((byte)HealthStatus.DisabilityOfSpeech): res = Resources.Resources.DisabilityOfSpeech; break;
                case ((byte)HealthStatus.DisabilityOfVision): res = Resources.Resources.DisabilityOfVision; break;
                case ((byte)HealthStatus.Blind): res = Resources.Resources.Blind; break;
                case ((byte)HealthStatus.Deaf): res = Resources.Resources.Deaf; break;
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;

            }
            return res;
        }
        //#####################################################
        public static string GetRelegion(byte? relige)
        {
            var res = "";
            switch (relige)
            {
                case ((byte)Religion.Islam): res = Resources.Resources.Islam; break;
                case ((byte)Religion.Christian): res = Resources.Resources.Christian; break;
                case ((byte)Religion.Jewish): res = Resources.Resources.Jewish; break;
                case ((byte)Religion.Zoroastrian): res = Resources.Resources.Zoroastrian; break;
                case ((byte)Religion.Other): res = Resources.Resources.Other; break;
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;

            }
            return res;
        }
        //#####################################################
        public static string GetDocType(byte? docTypeId)
        {
            var res = "";
            switch (docTypeId)
            {

                case ((byte)DocType.Passport): res = Resources.Resources.Passport; break;
                case ((byte)DocType.RefugeeBooklet): res = Resources.Resources.RefugeeBooklet; break;
                case ((byte)DocType.IdentityCardOfForeignCitizens): res = Resources.Resources.IdentityCardOfForeignCitizens; break;
                case ((byte)DocType.LimitedTransitCard): res = Resources.Resources.LimitedTransitCard; break;
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;

            }
            return res;
        }
        //#####################################################
        public static string MapperDocType(byte? docTypeId)
        {
            var res = "";
            switch (docTypeId)
            {
                case ((byte)DocType.Passport): res = Resources.Resources.Passport; break; //2
                case ((byte)DocType.RefugeeBooklet): res = Resources.Resources.RefugeeBooklet; break;//3
                case ((byte)DocType.IdentityCardOfForeignCitizens): res = Resources.Resources.IdentityCardOfForeignCitizens; break;//4
                case ((byte)DocType.LimitedTransitCard): res = Resources.Resources.LimitedTransitCard; break;//5

                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;

            }
            return res;
        }
        //#####################################################
        public static string GetRecommenderRelationship(byte? typeOfRelation)
        {
            var res = "";
            switch (typeOfRelation)
            {
                case ((byte)RelationType.Father): res = Resources.Resources.Father; break;          //2
                case ((byte)RelationType.Mother): res = Resources.Resources.Mother; break;          //3
                case ((byte)RelationType.GrandFather): res = Resources.Resources.GrandFather; break;     //4
                case ((byte)RelationType.Brother): res = Resources.Resources.Brother; break;         //5
                case ((byte)RelationType.Sister): res = Resources.Resources.Sister; break;          //6
                case ((byte)RelationType.Spouse): res = Resources.Resources.Spouse; break;          //7
                case ((byte)RelationType.Child): res = Resources.Resources.Child; break;           //8
                case ((byte)RelationType.Friend): res =Resources.Resources.Friend; break;           //11
                case ((byte)RelationType.Other): res =Resources.Resources.Other; break;            //12
                case (null): res = Resources.Resources.Other; break;            //12
                default:
                    res = Resources.Resources.Dropdown_Choose;
                    break;

            }
            return res;

        }


        public static string GetSidaLevelTitle(byte? level)
        {
            var res = "";
            switch (level)
            {
                case ((byte)SazmanLevels.Kardani): res = Resources.Resources.Kardani; break;
                case ((byte)SazmanLevels.Kardani_Peivasteh): res = Resources.Resources.Kardani; break;
                case ((byte)SazmanLevels.Karshenasi): res = Resources.Resources.KarshenasiPeivasteh; break;
                case ((byte)SazmanLevels.Karshenasi_Napeivasteh): res = Resources.Resources.KarshenasiNaPeivasteh; break;
                case ((byte)SazmanLevels.KarshenasiArshad): res = Resources.Resources.KarshenasiArshadPeivasteh; break;
                case ((byte)SazmanLevels.KarshenasiArshad_Peivasteh): res = Resources.Resources.KarshenasiArshadNaPeivasteh; break;
                case ((byte)SazmanLevels.PerfessionalDoctorate): res = Resources.Resources.PerfessionalDoctorate; break;
                case ((byte)SazmanLevels.SpecialDoctorate): res = Resources.Resources.SpecialDoctorate; break;
                default:
                    res = Resources.Resources.UnKnown;
                    break;
            }
            return res;
        }

    }
}
