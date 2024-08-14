export const formatHarga = (value) => {
    const formater = new Intl.NumberFormat('id-ID', { 
        style: 'decimal',
        minimumFractionDigits: 0 });
    return formater.format(value);
};

export const maskedPassword = (value) => {
    if (value === undefined || value === null) return '';
    return '*'.repeat(value.length + 3);
};

export function isUnique(array, key, value) {
    return !array.some(item => item[key] === value);
}

export const toUpperCase = (value) => {
    if (typeof value !== 'string') return '';
    return value.toUpperCase();
};

export function toUpperCaseFields(obj, fields) {
    fields.forEach(field => {
      if (obj[field]) {
        obj[field] = obj[field].toUpperCase();
      }
    });
  }

export function filterData(data, searchQuery) {
    return data.filter(item => 
        (item.nama && item.nama.toLowerCase().includes(searchQuery.toLowerCase())) ||
        (item.kode && item.kode.toString().toLowerCase().includes(searchQuery.toLowerCase()))
    );
}
