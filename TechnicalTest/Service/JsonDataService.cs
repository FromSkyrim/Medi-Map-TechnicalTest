using System.Collections.Generic;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json;
using TechnicalTest.Model;


namespace TechnicalTest.Service
{
    public class JsonDataService
    {
        private readonly string _basePath;

        public JsonDataService(IWebHostEnvironment env)
        {
            _basePath = env.ContentRootPath;
        }

        public IEnumerable<PatientDetails> GetPatientData()
        {
            string filePath = Path.Combine(_basePath, "data", "patientsdata.json");
            using (var reader = new StreamReader(filePath))
            {
                string json = reader.ReadToEnd();
                return JsonConvert.DeserializeObject<List<PatientDetails>>(json);
            }
        }
    }
}

