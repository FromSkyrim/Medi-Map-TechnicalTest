using Moq;
using Xunit;
using System.Threading.Tasks;
using TechnicalTest.Controllers;
using TechnicalTest.Interface;
using TechnicalTest.Model;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;

namespace Tests
{
    public class PatientTest
    {
        private readonly Mock<IJsonDataService> _mockJsonDataService = new Mock<IJsonDataService>();
        private readonly Mock<IDatabaseService> _mockDatabaseService = new Mock<IDatabaseService>();
        private readonly PatientController _controller;

        public PatientTest()
        {
            // Setup the controller with mocked services
            _controller = new PatientController(_mockJsonDataService.Object, _mockDatabaseService.Object);
        }

        [Fact]
        public async Task ProcessData_ShouldCallDatabaseService_WhenPatientsExist()
        {
            // Arrange
            var patients = new List<PatientDetails>
            {
                new PatientDetails { PatientID = 1, FirstName = "John", LastName = "Doe" }
            };
            _mockJsonDataService.Setup(service => service.GetPatientData()).Returns(patients);
            _mockDatabaseService.Setup(service => service.CheckPatientExists(It.IsAny<int>())).ReturnsAsync(true);
            _mockDatabaseService.Setup(service => service.InsertMedicationAdministrationRecord(It.IsAny<int>(), It.IsAny<decimal>(), It.IsAny<int>()));

            // Act
            var result = await _controller.ProcessData();

            // Assert
            _mockDatabaseService.Verify(service => service.CheckPatientExists(It.IsAny<int>()), Times.AtLeastOnce());
            _mockDatabaseService.Verify(service => service.InsertMedicationAdministrationRecord(It.IsAny<int>(), It.IsAny<decimal>(), It.IsAny<int>()), Times.AtLeastOnce());
            Assert.IsType<OkObjectResult>(result);
        }

        [Fact]
        public async Task ProcessData_ShouldHandleExceptionsProperly()
        {
            // Arrange
            var exceptionMessage = "Database unavailable";
            var patients = new List<PatientDetails>
            {
                new PatientDetails { PatientID = 1, FirstName = "John", LastName = "Doe" }
            };
            _mockJsonDataService.Setup(service => service.GetPatientData()).Returns(patients);
            _mockDatabaseService.Setup(service => service.CheckPatientExists(It.IsAny<int>())).ThrowsAsync(new Exception(exceptionMessage));
            _mockDatabaseService.Setup(service => service.LogError(It.IsAny<string>()));

            // Act
            Func<Task> act = async () => await _controller.ProcessData();

            // Assert
            var exception = await Assert.ThrowsAsync<Exception>(act);
            Assert.Equal(exceptionMessage, exception.Message);
            _mockDatabaseService.Verify(service => service.LogError(It.Is<string>(s => s.Contains("Error processing patient data"))), Times.Once());
        }

        [Fact]
        public async Task ProcessData_ShouldReturnNotFound_WhenNoPatientsExist()
        {
            // Arrange
            var emptyPatients = new List<PatientDetails>();
            _mockJsonDataService.Setup(service => service.GetPatientData()).Returns(emptyPatients);

            // Act
            var result = await _controller.ProcessData();

            // Assert
            _mockDatabaseService.Verify(service => service.CheckPatientExists(It.IsAny<int>()), Times.Never());
            _mockDatabaseService.Verify(service => service.InsertMedicationAdministrationRecord(It.IsAny<int>(), It.IsAny<decimal>(), It.IsAny<int>()), Times.Never());
            var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
            Assert.Equal("No patient data available.", notFoundResult.Value);
        }

    }
}
