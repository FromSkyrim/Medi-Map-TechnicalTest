namespace TechnicalTest.Utility
{
    public static class HealthMetricsCalculator
    {
        public static decimal CalculateBMI(decimal weight, decimal height)
        {
            if (height == 0) return 0;
            decimal heightInMeters = height / 100;
            return weight / (heightInMeters * heightInMeters);
        }
    }
}


