function number_to_currency(number, format) {
  var match, defaultFormat, property, integerPart, fractionalPart;
        
  match = number.toString().match(/([\+\-]?[0-9]*)(.[0-9]+)?/);

  if (!match) return;

  defaultFormat = { precision:2, unit: "$", separator: ".", delimiter   : "," };
        
  format = format || {};
  for (property in defaultFormat)
    format[property] = format[property] || defaultFormat[property];
        
  integerPart = match[1].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + format.delimiter);
  fractionalPart = (match[2].toString() + "000000000000").substr(1, format.precision);

  return format.unit + integerPart + format.separator + fractionalPart;
}