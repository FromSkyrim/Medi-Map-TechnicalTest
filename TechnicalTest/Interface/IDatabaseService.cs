using System.Threading.Tasks;
using TechnicalTest.Model;

namespace TechnicalTest.Interface
{
    public interface IDatabaseService
    {
        Task<bool> CheckPatientExists(int patientId);
        Task InsertPatient(PatientDetails patient);
        Task InsertMedicationAdministrationRecord(int patientId, decimal bmi, int medicationId);
        Task LogError(string message);
    }
}

