namespace TravelPlanner.UI.Models
{
    public class ResultDto
    {
        public bool isSuccess { get; set; }

        public string? Message { get; set; }

        public object? Data { get; set; }
    }
}
