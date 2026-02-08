# 💰 Complete Pricing Configuration

Your actual electricity costs including all fees and taxes.

---

## 📊 Your Pricing Structure

### Fixed Costs (Already Including ALV 25.5%)

| Component | Price | Unit | Notes |
|-----------|-------|------|-------|
| **Electric Tax** | 2.827515 c/kWh | per kWh | Government tax |
| **Marginal** | 0.59 c/kWh | per kWh | Company margin |
| **Base Fee** | 5.99 € | per month | Fixed monthly cost |
| **Transfer (Day)** | 5.11 c/kWh | per kWh | 07:00-22:00 |
| **Transfer (Night)** | 3.12 c/kWh | per kWh | 22:00-07:00 |

### Variable Cost
| Component | Price | Notes |
|-----------|-------|-------|
| **Nordpool Spot** | Varies hourly | Market price + ALV 25.5% |

---

## 🧮 Total Price Calculation

### Formula:
```
Total Price (c/kWh) = Nordpool Spot (incl. ALV)
                     + Electric Tax (2.827515 c/kWh)
                     + Marginal (0.59 c/kWh)
                     + Transfer (5.11 or 3.12 c/kWh)
```

### Example Calculations:

#### Day Time (07:00-22:00):
```
Nordpool: 5.00 c/kWh (with ALV)
+ Tax:    2.83 c/kWh
+ Margin: 0.59 c/kWh
+ Transfer: 5.11 c/kWh (DAY)
─────────────────────
= Total:  13.53 c/kWh
```

#### Night Time (22:00-07:00):
```
Nordpool: 3.00 c/kWh (with ALV)
+ Tax:    2.83 c/kWh
+ Margin: 0.59 c/kWh
+ Transfer: 3.12 c/kWh (NIGHT)
─────────────────────
= Total:  9.54 c/kWh
```

---

## 💡 Cost Savings Analysis

### Transfer Fee Difference:
```
Day rate:   5.11 c/kWh
Night rate: 3.12 c/kWh
Savings:    1.99 c/kWh (39% cheaper at night!)
```

### Example Savings (1000 kWh/month):
```
If 70% used during day:   700 kWh × 13.53 c = 94.71 €
                         300 kWh ×  9.54 c = 28.62 €
                         Base fee           =  5.99 €
                         Total             = 129.32 €

If optimized (50% night): 500 kWh × 13.53 c = 67.65 €
                         500 kWh ×  9.54 c = 47.70 €
                         Base fee           =  5.99 €
                         Total             = 121.34 €
                         
Monthly Savings:                             7.98 €
Annual Savings:                             95.76 €
```

---

## 🎯 Optimization Strategy

### Priority 1: Avoid High Nordpool Hours
- Use when Nordpool spot < 5 c/kWh
- Save: 1-5 c/kWh on variable component

### Priority 2: Use Night Transfer Rate
- Schedule flexible loads 22:00-07:00
- Save: 1.99 c/kWh guaranteed

### Priority 3: Combine Both
- Best time: Night hours + Low spot price
- Maximum savings: Up to 7 c/kWh difference!

---

## 📈 Monthly Cost Breakdown

### Typical Month (1000 kWh):
```
Component              Day (700 kWh)    Night (300 kWh)    Total
─────────────────────────────────────────────────────────────────
Nordpool (avg 5/3 c)   35.00 €          9.00 €            44.00 €
Electric Tax           19.79 €          8.48 €            28.27 €
Marginal               4.13 €           1.77 €             5.90 €
Transfer               35.77 €          9.36 €            45.13 €
Base Fee               -                -                  5.99 €
─────────────────────────────────────────────────────────────────
Subtotal               94.69 €          28.61 €          129.29 €
```

---

## 🔧 Configuration for Home Assistant

See the template sensors in the next section that calculate:
1. Current transfer tariff (day/night)
2. Real-time total price per kWh
3. Hourly cost in euros
4. Daily/monthly costs
5. Savings from optimization

---

**All prices include ALV 25.5%**  
**Last Updated:** February 2026
