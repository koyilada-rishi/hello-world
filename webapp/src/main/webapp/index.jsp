<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Operations Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            color-scheme: light dark;
            --bg: #0f172a;
            --surface: #1e293b;
            --surface-contrast: #111827;
            --text: #f8fafc;
            --muted: #94a3b8;
            --accent: #38bdf8;
            --accent-soft: rgba(56, 189, 248, 0.15);
            --positive: #22c55e;
            --negative: #ef4444;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: radial-gradient(circle at 20% 20%, rgba(56, 189, 248, 0.12), transparent 35%),
                        radial-gradient(circle at 80% 30%, rgba(34, 197, 94, 0.12), transparent 45%),
                        var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding: 32px;
            display: flex;
            justify-content: center;
        }

        .dashboard {
            width: min(1200px, 100%);
            display: grid;
            gap: 24px;
        }

        header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        header h1 {
            font-size: 2rem;
            font-weight: 700;
        }

        .date-picker {
            display: flex;
            gap: 12px;
            align-items: center;
            background: rgba(148, 163, 184, 0.08);
            border: 1px solid rgba(148, 163, 184, 0.1);
            border-radius: 999px;
            padding: 6px 14px;
            color: var(--muted);
            font-weight: 500;
        }

        .grid {
            display: grid;
            gap: 24px;
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .card {
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.9), rgba(30, 41, 59, 0.95));
            border: 1px solid rgba(148, 163, 184, 0.12);
            border-radius: 20px;
            padding: 20px;
            backdrop-filter: blur(12px);
            position: relative;
            overflow: hidden;
        }

        .card::after {
            content: "";
            position: absolute;
            inset: 0;
            background: radial-gradient(circle at top right, rgba(56, 189, 248, 0.18), transparent 45%);
            pointer-events: none;
        }

        .card h2 {
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--muted);
            margin-bottom: 16px;
        }

        .stat {
            font-size: 2rem;
            font-weight: 600;
        }

        .trend {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
            font-weight: 500;
        }

        .trend.positive {
            color: var(--positive);
        }

        .trend.negative {
            color: var(--negative);
        }

        .chart-card {
            grid-column: 1 / -1;
            padding-bottom: 28px;
        }

        canvas {
            width: 100% !important;
            height: 320px !important;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 12px 0;
            color: var(--muted);
        }

        tr + tr {
            border-top: 1px solid rgba(148, 163, 184, 0.08);
        }

        th {
            font-size: 0.85rem;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: rgba(248, 250, 252, 0.75);
        }

        .progress {
            height: 8px;
            background: rgba(148, 163, 184, 0.15);
            border-radius: 999px;
            overflow: hidden;
            margin-top: 8px;
        }

        .progress span {
            display: block;
            height: 100%;
            border-radius: inherit;
            background: linear-gradient(90deg, rgba(56, 189, 248, 0.7), rgba(56, 189, 248, 1));
        }

        ul.task-list {
            list-style: none;
            display: grid;
            gap: 16px;
        }

        ul.task-list li {
            display: grid;
            gap: 8px;
            padding: 16px;
            border-radius: 16px;
            background: rgba(15, 23, 42, 0.65);
            border: 1px solid rgba(148, 163, 184, 0.12);
        }

        .task-meta {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--muted);
        }

        .badge {
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(56, 189, 248, 0.2);
            color: var(--accent);
            font-weight: 600;
        }

        footer {
            text-align: center;
            color: var(--muted);
            font-size: 0.75rem;
            padding: 8px 0 12px;
        }

        @media (max-width: 640px) {
            body {
                padding: 20px;
            }

            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            canvas {
                height: 240px !important;
            }
        }
    </style>
</head>
<body>
<div class="dashboard">
    <header>
        <div>
            <p class="badge">Operations Overview</p>
            <h1>Realtime Performance Dashboard</h1>
        </div>
        <div class="date-picker">
            <span>📅</span>
            <span id="period-label">Last 30 Days</span>
        </div>
    </header>

    <section class="grid">
        <div class="kpi-grid">
            <article class="card">
                <h2>Total Revenue</h2>
                <div class="stat" id="revenue-stat">$1.28M</div>
                <div class="trend positive" id="revenue-trend">▲ 8.4% vs last month</div>
            </article>
            <article class="card">
                <h2>Active Subscriptions</h2>
                <div class="stat" id="subs-stat">18,420</div>
                <div class="trend positive" id="subs-trend">▲ 3.2% vs last month</div>
            </article>
            <article class="card">
                <h2>Churn Rate</h2>
                <div class="stat" id="churn-stat">2.1%</div>
                <div class="trend negative" id="churn-trend">▼ -0.5 pts vs last month</div>
            </article>
            <article class="card">
                <h2>Customer Satisfaction</h2>
                <div class="stat" id="csat-stat">94%</div>
                <div class="trend positive" id="csat-trend">▲ 1.6 pts vs last month</div>
            </article>
        </div>

        <article class="card chart-card">
            <h2>Monthly Revenue vs. New Customers</h2>
            <canvas id="performanceChart"></canvas>
        </article>

        <div class="grid-2">
            <article class="card">
                <h2>Top Performing Regions</h2>
                <table>
                    <thead>
                    <tr>
                        <th>Region</th>
                        <th>Revenue</th>
                        <th>Growth</th>
                    </tr>
                    </thead>
                    <tbody id="region-table"></tbody>
                </table>
            </article>

            <article class="card">
                <h2>Team Focus</h2>
                <ul class="task-list" id="task-list"></ul>
            </article>
        </div>

        <div class="grid-2">
            <article class="card">
                <h2>Pipeline Health</h2>
                <p style="color: var(--muted); font-size: 0.9rem;">Forecast coverage for the next quarter</p>
                <div class="progress" style="margin-top: 18px;">
                    <span id="pipeline-progress" style="width: 72%;"></span>
                </div>
                <div class="trend positive" style="margin-top: 20px;" id="pipeline-label">72% of target reached</div>
            </article>

            <article class="card">
                <h2>Incident Response</h2>
                <p style="color: var(--muted); font-size: 0.9rem;">Average time to resolution</p>
                <div class="stat" style="font-size: 1.8rem; margin-top: 14px;" id="incidents-stat">58m</div>
                <div class="trend positive" id="incidents-trend">▲ 12% faster week-over-week</div>
            </article>
        </div>
    </section>

    <footer>
        Updated in realtime • Generated for leadership review
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const formatNumber = (value) => value.toLocaleString('en-US');
    const regions = [
        { name: 'North America', revenue: 486000, growth: 12.4 },
        { name: 'Europe', revenue: 372500, growth: 9.1 },
        { name: 'APAC', revenue: 298700, growth: 15.3 },
        { name: 'LATAM', revenue: 126200, growth: 6.8 }
    ];

    const tasks = [
        { name: 'Finalize Q4 roll-out plan', owner: 'Product', progress: 84 },
        { name: 'Launch customer advocacy program', owner: 'Marketing', progress: 62 },
        { name: 'Expand enterprise onboarding', owner: 'Success', progress: 43 },
        { name: 'Optimize cloud spend initiative', owner: 'Ops', progress: 71 }
    ];

    function populateRegions() {
        const tbody = document.getElementById('region-table');
        tbody.innerHTML = regions.map(region => `
            <tr>
                <td>${region.name}</td>
                <td>$${formatNumber(region.revenue)}</td>
                <td class="trend ${region.growth >= 0 ? 'positive' : 'negative'}">
                    ${region.growth >= 0 ? '▲' : '▼'} ${Math.abs(region.growth)}%
                </td>
            </tr>`).join('');
    }

    function populateTasks() {
        const list = document.getElementById('task-list');
        list.innerHTML = tasks.map(task => `
            <li>
                <div class="task-meta">
                    <strong>${task.name}</strong>
                    <span>${task.owner}</span>
                </div>
                <div class="progress"><span style="width: ${task.progress}%"></span></div>
            </li>`).join('');
    }

    function animateStats() {
        const revenueBase = 1280000;
        const subsBase = 18420;
        const churnBase = 2.1;
        const csatBase = 94;

        setInterval(() => {
            const variation = (Math.random() - 0.5) * 0.04; // +/- 2%
            const revenue = revenueBase * (1 + variation);
            document.getElementById('revenue-stat').textContent = `$${(revenue / 1000000).toFixed(2)}M`;
            document.getElementById('subs-stat').textContent = formatNumber(Math.round(subsBase * (1 + variation)));

            const churnVariation = (Math.random() - 0.5) * 0.4;
            document.getElementById('churn-stat').textContent = `${(churnBase + churnVariation).toFixed(1)}%`;

            const csatVariation = (Math.random() - 0.5) * 1.5;
            document.getElementById('csat-stat').textContent = `${(csatBase + csatVariation).toFixed(1)}%`;
        }, 4500);
    }

    function renderChart() {
        const ctx = document.getElementById('performanceChart').getContext('2d');
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const baseRevenue = [
            820, 860, 910, 955, 1010, 1065, 1120, 1180, 1240, 1310, 1380, 1450
        ];
        const baseCustomers = [
            230, 250, 240, 265, 280, 300, 320, 340, 355, 370, 390, 410
        ];

        const gradient = ctx.createLinearGradient(0, 0, 0, 320);
        gradient.addColorStop(0, 'rgba(56, 189, 248, 0.4)');
        gradient.addColorStop(1, 'rgba(56, 189, 248, 0.05)');

        const chart = new Chart(ctx, {
            data: {
                labels: months,
                datasets: [
                    {
                        type: 'line',
                        label: 'Revenue ($K)',
                        data: baseRevenue,
                        tension: 0.4,
                        borderColor: 'rgba(56, 189, 248, 1)',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointRadius: 0,
                        fill: true
                    },
                    {
                        type: 'bar',
                        label: 'New Customers',
                        data: baseCustomers,
                        backgroundColor: 'rgba(34, 197, 94, 0.5)',
                        borderRadius: 8,
                        yAxisID: 'y1'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { intersect: false, mode: 'index' },
                plugins: {
                    legend: {
                        labels: {
                            color: 'rgba(248, 250, 252, 0.8)',
                            boxWidth: 12,
                            boxHeight: 12,
                            font: { size: 12 }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(15, 23, 42, 0.95)',
                        borderColor: 'rgba(148, 163, 184, 0.25)',
                        borderWidth: 1,
                        titleColor: '#f8fafc',
                        bodyColor: '#e2e8f0'
                    }
                },
                scales: {
                    x: {
                        ticks: {
                            color: 'rgba(148, 163, 184, 0.7)'
                        },
                        grid: {
                            display: false
                        }
                    },
                    y: {
                        type: 'linear',
                        position: 'left',
                        ticks: {
                            color: 'rgba(148, 163, 184, 0.7)',
                            callback: value => `$${value}`
                        },
                        grid: {
                            color: 'rgba(148, 163, 184, 0.08)'
                        }
                    },
                    y1: {
                        type: 'linear',
                        position: 'right',
                        ticks: {
                            color: 'rgba(148, 163, 184, 0.6)'
                        },
                        grid: {
                            drawOnChartArea: false
                        }
                    }
                }
            }
        });

        setInterval(() => {
            const newRevenue = chart.data.datasets[0].data.map((value, index) => {
                const jitter = (Math.random() - 0.5) * 40;
                return Math.max(value + jitter, 650 + index * 40);
            });
            const newCustomers = chart.data.datasets[1].data.map(value => {
                const jitter = (Math.random() - 0.5) * 18;
                return Math.max(value + jitter, 200);
            });

            chart.data.datasets[0].data = newRevenue;
            chart.data.datasets[1].data = newCustomers;
            chart.update('active');
        }, 6000);
    }

    function updatePipeline() {
        setInterval(() => {
            const pipeline = 68 + Math.random() * 12;
            const resolution = 45 + Math.random() * 30;
            const responseImprovement = 8 + Math.random() * 8;

            document.getElementById('pipeline-progress').style.width = `${pipeline.toFixed(1)}%`;
            document.getElementById('pipeline-label').textContent = `${pipeline.toFixed(0)}% of target reached`;

            document.getElementById('incidents-stat').textContent = `${resolution.toFixed(0)}m`;
            document.getElementById('incidents-trend').textContent = `▲ ${responseImprovement.toFixed(1)}% faster week-over-week`;
        }, 5000);
    }

    populateRegions();
    populateTasks();
    animateStats();
    renderChart();
    updatePipeline();
</script>
</body>
</html>
