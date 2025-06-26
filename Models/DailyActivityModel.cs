namespace PortActivityAPI.Models
{
    public class DailyActivityModel
    {
        public int PortCode { get; set; }
        public string PortName { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public int? CargoTypeId { get; set; }
        public string CargoType { get; set; }
        public DateTime Date { get; set; }
        public decimal ImportVolume { get; set; }
        public decimal ExportVolume { get; set; }
    }
}