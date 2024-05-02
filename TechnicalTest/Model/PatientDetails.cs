using System;

namespace TechnicalTest.Model
{
    public class PatientDetails
    {
        public int PatientID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public DateTime DOB { get; set; }
        public decimal HeightCms { get; set; }
        public decimal WeightKgs { get; set; }
        public int MedicationID { get; set; }
        public string MedicationName { get; set; }
    }
}
