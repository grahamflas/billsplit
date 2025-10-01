export const formatCurrency = (amount: number) => {
  return Intl.NumberFormat("de-DE", {
    style: "currency",
    currency: "EUR",
  }).format(Math.abs(amount));
};
