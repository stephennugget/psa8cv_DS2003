import requests
import pandas as pd
import matplotlib.pyplot as plt

# constants
API_KEY = 'ojg7FuKjaI5gH66aOKzAo5NDJo2vJfvr92Qza1Jp'
BASE_URL = 'https://yfapi.net/v6/finance/quote'
TRENDING_URL = 'https://yfapi.net/v1/finance/trending/US'
QUOTE_SUMMARY_URL = 'https://yfapi.net/v11/finance/quoteSummary/'


def get_stock_data(ticker):
    headers = {'x-api-key': API_KEY}
    params = {'symbols': ticker}
    response = requests.get(BASE_URL, headers=headers, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        return None
    
def get_target_mean_price(ticker):
    headers = {'x-api-key': API_KEY}
    params = {'modules': 'financialData'}
    response = requests.get(f"{QUOTE_SUMMARY_URL}{ticker}", headers=headers, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        return None

def get_trending_stocks():
    headers = {'x-api-key': API_KEY}
    response = requests.get(TRENDING_URL, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        return None

def main():
    ticker = input("Please enter a stock ticker symbol: ").strip()
    stock_data = get_stock_data(ticker)
    
    if stock_data and 'quoteResponse' in stock_data and stock_data['quoteResponse']['result']:
        stock_info = stock_data['quoteResponse']['result'][0]
        print(f"Ticker: {stock_info['symbol']}")
        print(f"Full Name: {stock_info['longName']}")
        print(f"Current Market Price: ${stock_info['regularMarketPrice']}")
        
        target_data = get_target_mean_price(ticker)
        if target_data and 'quoteSummary' in target_data and 'result' in target_data['quoteSummary']:
            financial_data = target_data['quoteSummary']['result'][0]['financialData']
            target_mean_price = financial_data.get('targetMeanPrice', {}).get('raw')
            if target_mean_price:
                print(f"Target Mean Price: ${target_mean_price}")
            else:
                print("Target Mean Price: N/A")
        
        print(f"52 Week High: ${stock_info['fiftyTwoWeekHigh']}")
        print(f"52 Week Low: ${stock_info['fiftyTwoWeekLow']}")
        
        # csv
        df = pd.DataFrame([stock_info])
        df.to_csv(f"{ticker}_stock_data.csv", index=False)
        
        # trending data
        trending_data = get_trending_stocks()
        if trending_data and 'finance' in trending_data and 'result' in trending_data['finance']:
            trending_stocks = trending_data['finance']['result'][0]['quotes'][:5]
            print("Top 5 Trending Stocks:")
            for stock in trending_stocks:
                print(stock['symbol'])
        
        # bonus
        historical_url = f"https://yfapi.net/v8/finance/chart/{ticker}"
        params = {'range': '5d', 'interval': '1d'}
        headers = {'x-api-key': API_KEY}
        response = requests.get(historical_url, headers=headers, params=params)
        if response.status_code == 200:
            historical_data = response.json()
            if 'chart' in historical_data and 'result' in historical_data['chart']:
                result = historical_data['chart']['result'][0]
                timestamps = result['timestamp']
                highs = result['indicators']['quote'][0]['high']
                dates = pd.to_datetime(timestamps, unit='s')
                
                plt.figure(figsize=(12, 6))
                plt.plot(dates, highs, marker='o', label=ticker)
                plt.title(f"{ticker} - Highest Prices Over the Last 5 Days")
                plt.xlabel("Date")
                plt.ylabel("Price")
                plt.legend()
                plt.tight_layout()  
                plt.show()
        
    else:
        print(f"Failed to fetch data for {ticker}")

if __name__ == "__main__":
    main()