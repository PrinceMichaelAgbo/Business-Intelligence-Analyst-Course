Drop Database If Exists predicted_outputs;
Create Database If Not Exists predicted_outputs;
use predicted_outputs;

Drop Table If Exists predicted_outputs;
Create Table predicted_outputs
(
	reason_1 Bit Not Null,
    reason_2 Bit Not Null,
    reason_3 Bit Not Null,
    reason_4 Bit Not Null,
    month_value Int Not Null,
    transportation_expense Int Not Null,
    age Int Not Null,
    body_mass_index Int Not Null,
    education Bit Not Null,
    children Int Not Null,
    pets Int Not Null,
    probability Float Not Null,
    prediction Bit Not Null
);

Select * From predicted_outputs;



