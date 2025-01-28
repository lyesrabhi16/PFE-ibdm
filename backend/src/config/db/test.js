
const getDateTime = (date) =>{
    const now = date || new Date();
    return now.toLocaleString("fr", {
        dateStyle: "short",
        hour12: false,
        timeStyle: "medium",
    }) + `.${now.getMilliseconds()}`;
}
console.log('date_now: ', getDateTime());

