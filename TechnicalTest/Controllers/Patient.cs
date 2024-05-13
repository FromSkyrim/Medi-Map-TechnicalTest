using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using TechnicalTest.Interface;
using TechnicalTest.Utility;

namespace TechnicalTest.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PatientController : ControllerBase
    {
        private readonly IJsonDataService _jsonDataService;
        private readonly IDatabaseService _databaseService;

        public PatientController(IJsonDataService jsonDataService, IDatabaseService databaseService)
        {
            _jsonDataService = jsonDataService;
            _databaseService = databaseService;
        }

        [HttpPost("process-data")]
        public async Task<IActionResult> ProcessData()
        {
            try
            {
                var patients = _jsonDataService.GetPatientData();
                if (!patients.Any())
                {
                    return NotFound("No patient data available.");
                }
                foreach (var patient in patients)
                {
                    bool exists = await _databaseService.CheckPatientExists(patient.PatientID);
                    if (!exists)
                    {
                        await _databaseService.InsertPatient(patient);
                    }
                    decimal bmi = HealthMetricsCalculator.CalculateBMI(patient.WeightKgs, patient.HeightCms);
                    await _databaseService.InsertMedicationAdministrationRecord(patient.PatientID, bmi, patient.MedicationID);
                }
                return Ok("Data processed successfully.");
            }
            catch (Exception ex)
            {
                await _databaseService.LogError("Error processing patient data:" + ex.Message);
                throw; // Preserve stack trace and re-throw the exception
            }
        }
    }
}
