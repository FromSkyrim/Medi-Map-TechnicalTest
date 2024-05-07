using System.Collections.Generic;
using System.Threading.Tasks;
using TechnicalTest.Model;

namespace TechnicalTest.Interface
{
    public interface IJsonDataService
    {
        IEnumerable<PatientDetails> GetPatientData();
    }
}

