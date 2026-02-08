# 🤖 AI-Enhanced Power Management

Leverage Home Assistant's AI capabilities to add intelligent analysis, natural language reporting, and predictive insights to your power management system.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [AI Integrations](#ai-integrations)
3. [Daily Energy Reports](#daily-energy-reports)
4. [Weekly Analysis](#weekly-analysis)
5. [Anomaly Detection](#anomaly-detection)
6. [Natural Language Queries](#natural-language-queries)
7. [Predictive Optimization](#predictive-optimization)
8. [Voice Notifications](#voice-notifications)
9. [Implementation Guide](#implementation-guide)

---

## 🎯 Overview

Home Assistant's AI capabilities can transform your power management system by:

- 📊 **Intelligent Reporting** - Natural language summaries of energy usage
- 🔍 **Pattern Analysis** - Identify trends and anomalies in consumption
- 💡 **Smart Recommendations** - AI-driven optimization suggestions
- 🗣️ **Voice Interface** - Ask questions about your power usage
- 📈 **Predictive Insights** - Forecast usage and costs based on patterns
- ⚠️ **Anomaly Alerts** - Detect unusual consumption patterns

---

## 🔌 AI Integrations

### Supported AI Services

Home Assistant supports multiple AI providers:

1. **OpenAI (GPT-4)** - Best for complex analysis
2. **Anthropic (Claude)** - Excellent reasoning and detailed reports
3. **Google Gemini** - Good balance of speed and capability
4. **Local LLMs** - Privacy-focused with Ollama/LocalAI

### Setup

Already configured in your system:
```yaml
# You have: conversation.openai_conversation_4
# You have: conversation.openai_conversation_2
```

---

## 📊 Daily Energy Reports

### Morning Energy Summary

Get an AI-generated summary every morning with insights and recommendations.

**automation.yaml:**
```yaml
- id: ai_daily_energy_report
  alias: "AI - Daily Energy Report"
  description: "Morning energy summary with AI analysis"
  trigger:
    - platform: time
      at: "08:00:00"
  condition: []
  action:
    # Collect all energy data
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Analyze yesterday's energy consumption and provide insights.
          
          **Energy Data:**
          - Total consumption: {{ states('sensor.talon_kokonaiskulutus_viikko_kwh') }} kWh
          - Yesterday's usage: {{ states('input_number.sahkon_kulutus_edellinen_paiva') }} kWh
          - Peak power reached: {{ states('sensor.monthly_peak_power') }} kW
          - Tehomaksu charged: {{ states('sensor.current_month_tehomaksu_fee') }} €
          - Current electricity price: {{ states('sensor.electricity_total_price_cents') }} c/kWh
          
          **Power Factor Data:**
          - Overall power factor: {{ states('sensor.overall_power_factor') }}
          - Heat pump efficiency: {{ states('sensor.mitsu_ilp_power_factor') }}
          - Phase A power factor: {{ states('sensor.shellyem3_channel_a_power_factor') }}
          - Phase B power factor: {{ states('sensor.shellyem3_channel_b_power_factor') }}
          - Phase C power factor: {{ states('sensor.shellyem3_channel_c_power_factor') }}
          
          **Device Activity:**
          - Sauna usage: {{ states('sensor.saunan_tilatieto') }}
          - Heat pump mode: {{ state_attr('climate.mitsu_ilp', 'hvac_action') }}
          - Tesla charging: {{ states('sensor.shadow_battery_level') }}%
          - Boiler status: {{ states('switch.shellypro4pm_ec62609fd3dc_switch_2') }}
          
          **System Actions:**
          - Peak limiter interventions: {{ states('sensor.peak_limiter_interventions_today') }}
          - Load balancer activations: {{ states('sensor.load_balancer_activations_today') }}
          
          **Weather:**
          - Current temperature: {{ states('sensor.ulkolampotila') }}°C
          - Today's forecast: {{ state_attr('weather.koti', 'temperature') }}°C
          
          Please provide:
          1. Brief summary of yesterday's consumption (2-3 sentences)
          2. Notable patterns or anomalies
          3. Power factor analysis and equipment health
          4. One specific recommendation for today
          5. Estimated cost impact
          
          Keep the response conversational and under 200 words. Speak Finnish.
      response_variable: ai_report
    
    # Send as notification
    - service: notify.telegram
      data:
        title: "🏠 Aamun energiaraportti"
        message: "{{ ai_report.response.speech.plain.speech }}"
    
    # Optional: Read out loud
    - service: tts.google_cloud_say
      data:
        cache: false
        entity_id: media_player.nest_mini
        message: "{{ ai_report.response.speech.plain.speech }}"
```

**Example Output:**
> "Hyvää huomenta! Eilen sähkönkulutus oli 42 kWh, mikä on 15% normaalia vähemmän kiitos edullisten hintojen aikana tehdylle optimoinnille. Lämpöpumpun tehokerroin oli erinomainen 0.94, mikä viittaa hyvään kuntoon. 
>
> Huomionarvoista: Sauna käytettiin kalleimpaan aikaan kello 18-19, mikä maksoi 2.10€ enemmän kuin edullisimpaan aikaan käytettynä. Suositus: Lämmitä sauna tänä iltana kello 23 jälkeen kun hinta laskee 7 senttiin. 
>
> Tehomaksu tällä hetkellä 12.50€, ja pysymme turvallisesti alle 8 kW rajan."

---

## 📈 Weekly Analysis

### Sunday Evening Weekly Review

**automation.yaml:**
```yaml
- id: ai_weekly_energy_analysis
  alias: "AI - Weekly Energy Analysis"
  description: "Detailed weekly review with trends"
  trigger:
    - platform: time
      at: "20:00:00"
  condition:
    - condition: time
      weekday:
        - sun
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Create a comprehensive weekly energy analysis.
          
          **Week's Data:**
          - Total consumption: {{ states('sensor.talon_kokonaiskulutus_viikko_kwh') }} kWh
          - Average daily: {{ (states('sensor.talon_kokonaiskulutus_viikko_kwh') | float / 7) | round(1) }} kWh
          - Week's peak power: {{ states('sensor.week_peak_power') }} kW
          - Total cost: {{ states('sensor.week_electricity_cost') }} €
          - Average price paid: {{ states('sensor.week_avg_price_paid') }} c/kWh
          
          **Power Quality:**
          - Average power factor: {{ states('sensor.week_avg_power_factor') }}
          - Best PF day: {{ states('sensor.week_best_pf_day') }}
          - Worst PF day: {{ states('sensor.week_worst_pf_day') }}
          
          **Optimization Performance:**
          - Peak limiter saves: {{ states('sensor.week_peak_interventions') }} interventions
          - Price optimizer switches: {{ states('sensor.week_optimizer_actions') }}
          - Load balancer activations: {{ states('sensor.week_balancer_activations') }}
          
          **Device Usage Patterns:**
          - Sauna sessions: {{ states('sensor.week_sauna_sessions') }}
          - Heat pump runtime: {{ states('sensor.week_heatpump_hours') }} hours
          - Tesla charges: {{ states('sensor.week_tesla_charges') }}
          - Water boiler cycles: {{ states('sensor.week_boiler_cycles') }}
          
          **Comparison:**
          - Last week: {{ states('sensor.previous_week_consumption') }} kWh
          - Change: {{ ((states('sensor.talon_kokonaiskulutus_viikko_kwh') | float - states('sensor.previous_week_consumption') | float) / states('previous_week_consumption') | float * 100) | round(1) }}%
          
          Analyze:
          1. Week's consumption trend (increase/decrease and why)
          2. Most efficient day and why
          3. Power factor health assessment
          4. Automation system performance
          5. Top 3 recommendations for next week
          6. Estimated monthly projection
          
          Format as a structured report. Speak Finnish. Maximum 300 words.
      response_variable: weekly_report
    
    - service: notify.telegram
      data:
        title: "📊 Viikon energiayhteenveto"
        message: "{{ weekly_report.response.speech.plain.speech }}"
```

---

## 🚨 Anomaly Detection

### Real-time Consumption Anomaly Alert

**automation.yaml:**
```yaml
- id: ai_anomaly_detection
  alias: "AI - Consumption Anomaly Detection"
  description: "Detect and explain unusual power consumption"
  trigger:
    - platform: numeric_state
      entity_id: sensor.sahko_kokonaiskulutus_teho
      above: 15
      for:
        minutes: 10
  condition:
    # Only alert during unexpected times
    - condition: time
      after: "00:00:00"
      before: "06:00:00"
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          ANOMALY DETECTED! Analyze this unusual power consumption.
          
          **Current Situation:**
          - Current power: {{ states('sensor.sahko_kokonaiskulutus_teho') }} W
          - Time: {{ now().strftime('%H:%M') }}
          - Typical usage at this hour: 2000-3000 W
          
          **Active Devices:**
          - Sauna: {{ states('sensor.saunan_tilatieto') }}
          - Heat pump: {{ states('climate.mitsu_ilp') }} ({{ state_attr('climate.mitsu_ilp', 'current_temperature') }}°C)
          - Water boiler: {{ states('switch.shellypro4pm_ec62609fd3dc_switch_2') }}
          - Tesla charging: {{ states('binary_sensor.tesla_charging') }}
          - Phase A: {{ states('sensor.shellyem3_channel_a_power') }} W
          - Phase B: {{ states('sensor.shellyem3_channel_b_power') }} W
          - Phase C: {{ states('sensor.shellyem3_channel_c_power') }} W
          
          **Recent History:**
          - 1 hour ago: {{ states('sensor.power_1_hour_ago') }} W
          - 30 min ago: {{ states('sensor.power_30_min_ago') }} W
          
          Analyze:
          1. What device(s) are causing the high usage?
          2. Is this expected behavior?
          3. Is there a potential malfunction?
          4. Should action be taken?
          5. Risk to peak power limit (current: {{ states('sensor.rolling_average_60min') }} kW)
          
          Be concise and actionable. Speak Finnish.
      response_variable: anomaly_analysis
    
    - service: notify.telegram
      data:
        title: "⚠️ Epätavallinen kulutus havaittu"
        message: "{{ anomaly_analysis.response.speech.plain.speech }}"
        data:
          inline_keyboard:
            - "Tarkista järjestelmä:/check_system"
            - "Ei toimenpiteitä:/dismiss"
```

---

## 💬 Natural Language Queries

### On-Demand Power Status Query

Create a script to ask about power status anytime:

**scripts.yaml:**
```yaml
ai_power_status_query:
  alias: "AI Power Status Query"
  description: "Ask AI about current power situation"
  fields:
    question:
      description: "Your question about power usage"
      example: "Miksi kulutus on nyt niin korkea?"
  sequence:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          User question: "{{ question }}"
          
          **Current Real-time Data:**
          - Current power: {{ states('sensor.sahko_kokonaiskulutus_teho') }} W
          - 60-min average: {{ states('sensor.rolling_average_60min') }} kW
          - Current price: {{ states('sensor.electricity_total_price_cents') }} c/kWh
          - Today's consumption: {{ states('sensor.today_energy_consumption') }} kWh
          - Monthly peak: {{ states('sensor.monthly_peak_power') }} kW
          - Tehomaksu fee: {{ states('sensor.current_month_tehomaksu_fee') }} €
          
          **Active Devices:**
          - Sauna: {{ states('sensor.saunan_tilatieto') }}
          - Heat pump: {{ state_attr('climate.mitsu_ilp', 'hvac_action') }} @ {{ state_attr('climate.mitsu_ilp', 'current_temperature') }}°C
          - Tesla: {{ 'Charging' if is_state('binary_sensor.tesla_charging', 'on') else 'Not charging' }} ({{ states('sensor.shadow_battery_level') }}%)
          - Boiler: {{ states('switch.shellypro4pm_ec62609fd3dc_switch_2') }}
          - Radiators: {{ states('switch.patterit') }}
          
          **Power Quality:**
          - Overall PF: {{ states('sensor.overall_power_factor') }}
          - Phase A: {{ states('sensor.shellyem3_channel_a_power') }}W / {{ states('sensor.shellyem3_channel_a_power_factor') }}
          - Phase B: {{ states('sensor.shellyem3_channel_b_power') }}W / {{ states('sensor.shellyem3_channel_b_power_factor') }}
          - Phase C: {{ states('sensor.shellyem3_channel_c_power') }}W / {{ states('sensor.shellyem3_channel_c_power_factor') }}
          
          **Automation Status:**
          - Load balancer: {{ states('binary_sensor.load_balancer_active') }}
          - Peak limiter: {{ states('binary_sensor.peak_limiter_active') }}
          - Price optimizer: {{ states('input_boolean.power_management_active') }}
          
          Answer the user's question with relevant data. Be conversational and helpful. Speak Finnish.
      response_variable: ai_response
    
    - service: notify.telegram
      data:
        message: "{{ ai_response.response.speech.plain.speech }}"
```

**Usage in Dashboard:**
```yaml
type: button
name: "Kysy tekoälyltä"
tap_action:
  action: call-service
  service: script.ai_power_status_query
  data:
    question: "Mitä kotini sähkötilanteessa tapahtuu juuri nyt?"
```

**Voice Assistant Integration:**
```yaml
# Enable voice queries like:
# "Hey Google, ask Home Assistant about my power usage"
# "Alexa, tell Home Assistant to analyze my electricity"
```

---

## 🔮 Predictive Optimization

### AI-Powered Daily Optimization Plan

**automation.yaml:**
```yaml
- id: ai_daily_optimization_plan
  alias: "AI - Daily Optimization Plan"
  description: "AI creates optimized schedule for the day"
  trigger:
    - platform: time
      at: "06:00:00"
  action:
    # Get Nordpool prices for today
    - service: nordpool.get_prices
      response_variable: nordpool_prices
    
    # AI creates optimization plan
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Create today's optimization plan based on electricity prices and weather.
          
          **Today's Electricity Prices (24h):**
          {% for hour in range(24) %}
          {{ '%02d' % hour }}:00 - {{ state_attr('sensor.nordpool_kwh_fi_eur_4_10_0', 'raw_today')[hour] | float * 100 }} c/kWh
          {% endfor %}
          
          **Weather Forecast:**
          - Temperature: {{ state_attr('weather.koti', 'temperature') }}°C
          - Forecast low: {{ states('sensor.koti_realfeel_lampotila_min_tanaan') }}°C
          - Forecast high: {{ states('sensor.koti_realfeel_lampotila_max_tanaan') }}°C
          - Conditions: {{ states('sensor.koti_tilanne_tanaan') }}
          
          **Device Needs:**
          - Tesla battery: {{ states('sensor.shadow_battery_level') }}% (need to charge to 80%)
          - Water boiler: Last heated {{ relative_time(states.switch.shellypro4pm_ec62609fd3dc_switch_2.last_changed) }} ago
          - Heat pump current temp: {{ state_attr('climate.mitsu_ilp', 'current_temperature') }}°C
          
          **Constraints:**
          - Must avoid peak power over 8 kW (tehomaksu prevention)
          - Tesla charging: 11 kW for ~2 hours
          - Water boiler: 2 kW for 3 hours
          - Heat pump boost: 6-12 hours at cheapest times
          
          Create a schedule that:
          1. Identifies the 3 cheapest hours for water boiler
          2. Identifies the 2 cheapest consecutive hours for Tesla (if needed)
          3. Recommends 6 cheapest hours for heat pump boost mode
          4. Warns about expensive hours to avoid high consumption
          5. Estimates total cost for optimal vs. non-optimal scheduling
          
          Format as a clear action plan with times. Speak Finnish. Be specific.
      response_variable: optimization_plan
    
    # Save to input_text for dashboard display
    - service: input_text.set_value
      target:
        entity_id: input_text.ai_daily_plan
      data:
        value: "{{ optimization_plan.response.speech.plain.speech }}"
    
    # Send as notification
    - service: notify.telegram
      data:
        title: "🎯 Päivän optimointisuunnitelma"
        message: "{{ optimization_plan.response.speech.plain.speech }}"
```

---

## 🗣️ Voice Notifications

### Smart Voice Alerts with Context

**automation.yaml:**
```yaml
- id: ai_contextual_voice_alert
  alias: "AI - Contextual Voice Alert"
  description: "AI explains alerts with full context"
  trigger:
    - platform: state
      entity_id: binary_sensor.peak_limiter_active
      to: "on"
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Create a voice announcement explaining why peak limiter activated.
          
          **Current Situation:**
          - Current power: {{ states('sensor.sahko_kokonaiskulutus_teho') }} W
          - 60-min average: {{ states('sensor.rolling_average_60min') }} kW
          - Threshold: 8 kW
          - Risk level: {{ ((states('sensor.rolling_average_60min') | float / 8) * 100) | round(0) }}%
          
          **Active High-Power Devices:**
          {% if is_state('sensor.saunan_tilatieto', 'Päällä') %}- Sauna (9 kW){% endif %}
          {% if is_state('binary_sensor.tesla_charging', 'on') %}- Tesla charging ({{ states('sensor.tesla_charger_power') }} kW){% endif %}
          {% if is_state('switch.shellypro4pm_ec62609fd3dc_switch_2', 'on') %}- Water boiler (2 kW){% endif %}
          {% if is_state('switch.patterit', 'on') %}- Radiators (3 kW){% endif %}
          
          **Action Being Taken:**
          {{ states('sensor.peak_limiter_last_action') }}
          
          **Electricity Price Context:**
          - Current price: {{ states('sensor.electricity_total_price_cents') }} c/kWh
          - Rank in day: {{ states('sensor.current_price_rank') }}/24
          
          Create a 1-2 sentence natural explanation for voice output. 
          Be reassuring but informative. Speak Finnish.
          Don't use technical terms like "60-min rolling average" - say "keskimääräinen kulutus".
      response_variable: voice_explanation
    
    - service: tts.google_cloud_say
      data:
        cache: false
        entity_id: media_player.nest_mini
        message: "{{ voice_explanation.response.speech.plain.speech }}"
```

---

## 🔧 Implementation Guide

### Step 1: Verify AI Integration (5 minutes)

Check if OpenAI/Claude/Gemini is configured:

```yaml
# configuration.yaml
conversation:
  - platform: openai_conversation
    api_key: !secret openai_api_key
    model: "gpt-4"  # or gpt-3.5-turbo
```

Or use the UI:
1. Settings → Voice Assistants → Add Assistant
2. Choose OpenAI/Anthropic/Google
3. Enter API key
4. Note the entity ID (e.g., `conversation.openai_conversation_4`)

### Step 2: Create Helper Sensors (10 minutes)

**configuration.yaml:**
```yaml
# Store AI-generated reports
input_text:
  ai_daily_plan:
    name: "AI Daily Optimization Plan"
    max: 1000
    
  ai_weekly_summary:
    name: "AI Weekly Summary"
    max: 2000
    
  ai_last_anomaly:
    name: "AI Last Anomaly Analysis"
    max: 500

# Counter for tracking
counter:
  ai_reports_generated:
    name: "AI Reports Generated"
    icon: mdi:robot
```

### Step 3: Add Automations (20 minutes)

Copy the automations from sections above into your `automations.yaml`.

**Priority order:**
1. Daily Energy Report (most useful)
2. Natural Language Queries (most flexible)
3. Weekly Analysis (insightful)
4. Anomaly Detection (safety)
5. Predictive Optimization (advanced)

### Step 4: Create Dashboard Cards (15 minutes)

**dashboard.yaml:**
```yaml
type: vertical-stack
cards:
  # AI Daily Plan Display
  - type: markdown
    title: "🤖 AI Optimointisuunnitelma"
    content: "{{ states('input_text.ai_daily_plan') }}"
    
  # Quick Query Button
  - type: button
    name: "Kysy sähkötilanteesta"
    icon: mdi:robot
    tap_action:
      action: call-service
      service: script.ai_power_status_query
      data:
        question: "Analysoi nykyinen sähkötilanne"
    
  # AI Report Stats
  - type: entities
    title: "AI Raportointi"
    entities:
      - entity: counter.ai_reports_generated
        name: "Raportteja luotu"
      - entity: sensor.last_ai_report_time
        name: "Viimeisin raportti"
      - entity: input_boolean.ai_reports_enabled
        name: "AI raportit päällä"
```

### Step 5: Test & Iterate (30 minutes)

1. **Trigger test report:**
   ```yaml
   Developer Tools → Services:
   Service: automation.trigger
   Entity: automation.ai_daily_energy_report
   ```

2. **Review output quality:**
   - Too technical? → Add "explain in simple terms" to prompt
   - Too long? → Reduce word limit in prompt
   - Wrong language? → Verify "Speak Finnish" is in prompt

3. **Adjust prompts** based on your preferences

---

## 🎯 Advanced Use Cases

### 1. Equipment Health Monitoring

```yaml
# Monthly AI health check
- alias: "AI - Equipment Health Check"
  trigger:
    - platform: time
      at: "09:00:00"
  condition:
    - condition: template
      value_template: "{{ now().day == 1 }}"  # First of month
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Analyze equipment health based on last month's data.
          
          **Heat Pump:**
          - Monthly runtime: {{ states('sensor.heatpump_runtime_last_month') }} hours
          - Average power factor: {{ states('sensor.heatpump_avg_pf_last_month') }}
          - Energy consumed: {{ states('sensor.heatpump_energy_last_month') }} kWh
          - COP estimate: {{ states('sensor.heatpump_cop_last_month') }}
          
          **Power Quality:**
          - Phase imbalance events: {{ states('sensor.phase_imbalance_count_last_month') }}
          - Low voltage alerts: {{ states('sensor.low_voltage_alerts_last_month') }}
          - Average power factor: {{ states('sensor.month_avg_power_factor') }}
          
          **Tesla Charger:**
          - Charges completed: {{ states('sensor.tesla_charges_last_month') }}
          - Energy delivered: {{ states('sensor.tesla_energy_last_month') }} kWh
          - Average charge time: {{ states('sensor.tesla_avg_charge_time') }} hours
          
          Assess:
          1. Any equipment showing signs of degradation?
          2. Power quality concerns?
          3. Maintenance recommendations?
          4. Efficiency trends?
          
          Speak Finnish. Be technical but actionable.
```

### 2. Cost-Benefit Analysis

```yaml
# Analyze if system is worth it
- alias: "AI - System ROI Analysis"
  trigger:
    - platform: time
      at: "10:00:00"
  condition:
    - condition: template
      value_template: "{{ now().month == 1 and now().day == 1 }}"  # New Year
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Annual cost-benefit analysis of power management system.
          
          **Last Year's Performance:**
          - Total consumption: {{ states('sensor.year_total_kwh') }} kWh
          - Total cost: {{ states('sensor.year_total_cost') }} €
          - Peak power fees: {{ states('sensor.year_tehomaksu_total') }} €
          - System interventions: {{ states('sensor.year_total_interventions') }}
          
          **Estimated Without System:**
          - Avoided peak fees: {{ states('sensor.year_peak_fees_prevented') }} €
          - Price optimization benefit: {{ states('sensor.year_optimizer_benefit') }} €
          - Load balancing saves: {{ states('sensor.year_balancer_saves') }} €
          
          **Key Metrics:**
          - Average PF improvement: {{ states('sensor.year_pf_improvement') }}%
          - Peak power reduction: {{ states('sensor.year_peak_reduction') }} kW
          - Average price paid: {{ states('sensor.year_avg_price_paid') }} c/kWh
          - Market average price: {{ states('sensor.year_market_avg_price') }} c/kWh
          
          Create executive summary with:
          1. Total value delivered
          2. Most effective optimization
          3. Areas for improvement
          4. ROI percentage
          5. Recommendations for next year
```

### 3. Predictive Failure Detection

```yaml
# Detect early warning signs
- alias: "AI - Predictive Failure Detection"
  trigger:
    - platform: time_pattern
      hours: "/6"  # Every 6 hours
  action:
    - service: conversation.process
      data:
        agent_id: conversation.openai_conversation_4
        text: >
          Analyze for early warning signs of equipment failure.
          
          **Recent Anomalies:**
          - Power factor drops: {{ states('sensor.recent_pf_drops') }}
          - Unexpected consumption spikes: {{ states('sensor.recent_spikes') }}
          - Phase imbalances: {{ states('sensor.recent_imbalances') }}
          - Voltage fluctuations: {{ states('sensor.recent_voltage_issues') }}
          
          **Heat Pump Trends (7 days):**
          - Power factor trend: {{ states('sensor.heatpump_pf_trend') }}
          - Energy per runtime hour: {{ states('sensor.heatpump_efficiency_trend') }}
          - Startup current spikes: {{ states('sensor.heatpump_startup_current_trend') }}
          
          **Electrical System Health:**
          - Phase A/B/C balance: {{ states('sensor.phase_balance_score') }}
          - Voltage stability: {{ states('sensor.voltage_stability_score') }}
          - Harmonic distortion estimate: {{ states('sensor.thd_estimate') }}
          
          If any concerning patterns detected:
          1. Describe the issue in simple terms
          2. Severity level (1-10)
          3. Possible causes
          4. Recommended action
          5. Urgency (immediate/soon/monitor)
          
          If all normal, say "Kaikki järjestelmät toimivat normaalisti"
```

---

## 📱 Mobile App Integration

Add Siri/Google Assistant shortcuts:

**iOS Shortcut:**
```
Name: "Energy Status"
When I say: "How's my electricity?"
Action: 
  - Call Home Assistant script.ai_power_status_query
  - Show result as notification
```

**Android Widget:**
```yaml
# Create widget button in HA app
type: button
name: "🤖 AI Analyysi"
tap_action:
  action: call-service
  service: script.ai_power_status_query
  data:
    question: "Tiivistä tämänhetkinen tilanne"
```

---

## 💡 Tips for Better AI Reports

### Prompt Engineering

**Be Specific:**
```yaml
# ❌ Bad
text: "Analyze power usage"

# ✅ Good  
text: "Analyze power usage focusing on cost optimization opportunities. 
       Compare today's consumption to historical average. 
       Identify the most expensive hour and suggest alternatives."
```

**Provide Context:**
```yaml
# Always include:
- Relevant numerical data
- Time context (hour of day, day of week)
- Device states
- Price information
- Weather data (affects heating)
```

**Set Output Format:**
```yaml
# Request structure:
text: >
  Format your response as:
  1. Summary (1-2 sentences)
  2. Key finding
  3. Specific recommendation
  Keep under 150 words. Use bullet points. Speak Finnish.
```

### Cost Management

AI API calls cost money:
- GPT-4: ~$0.03-0.06 per report
- GPT-3.5-Turbo: ~$0.002 per report
- Claude: ~$0.01-0.03 per report
- Gemini: ~$0.001-0.01 per report

**Estimated monthly costs:**
- Daily report: $0.60-1.80/month (GPT-4)
- Weekly analysis: $0.12-0.72/month
- On-demand queries: Variable

**Optimize costs:**
1. Use GPT-3.5-Turbo for simple reports
2. Use GPT-4 only for complex analysis
3. Cache responses when possible
4. Set rate limits in automations

---

## 🎓 Next Steps

1. **Start Simple** - Begin with daily report automation
2. **Test Prompts** - Adjust based on output quality
3. **Add Complexity** - Once daily reports work, add weekly analysis
4. **Integrate Voice** - Add TTS for hands-free updates
5. **Custom Queries** - Create your own analysis automations

---

## 📚 Resources

- [Home Assistant AI Integration](https://www.home-assistant.io/integrations/openai_conversation/)
- [Conversation Integration](https://www.home-assistant.io/integrations/conversation/)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [Claude API Documentation](https://docs.anthropic.com/)
- [Google Gemini API](https://ai.google.dev/)

---

**Questions?** The AI can help with that too! 🤖

**Next:** Implement your first AI report and see the difference! 📊

