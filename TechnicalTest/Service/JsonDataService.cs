using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json;
using TechnicalTest.Model;
using Microsoft.Extensions.Logging;
using TechnicalTest.Interface;


namespace TechnicalTest.Service
{
    public class JsonDataService : IJsonDataService
    {
        private readonly string _basePath;
        private readonly ILogger<JsonDataService> _logger;

        public JsonDataService(IWebHostEnvironment env, ILogger<JsonDataService> logger)
        {
            _basePath = env.ContentRootPath;
            _logger = logger;
        }

        public IEnumerable<PatientDetails> GetPatientData()
        {
            try
            {
                string filePath = Path.Combine(_basePath, "data", "patientsdata.json");
                using (var reader = new StreamReader(filePath))
                {
                    string json = reader.ReadToEnd();
                    return JsonConvert.DeserializeObject<List<PatientDetails>>(json);
                }
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "Error parsing JSON: {Message}", ex.Message);
                return Enumerable.Empty<PatientDetails>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An unexpected error occurred while accessing the data.");
                return Enumerable.Empty<PatientDetails>();
            }
        }

    }
}

