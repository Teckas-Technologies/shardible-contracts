import requests
import json
url = "https://api.transpose.io/nft/owners-by-contract-address"
headers = {
    'Content-Type': 'application/json',
    'X-API-KEY': 'yOd3pB5GwS8111pmNjF7N0sWiYUrVPjs',
}
params = {
    "chain_id": "ethereum",
    "contract_address": "0xc17d21e5ecdc0ccf7a366eebd7fccdab68c1e733",
    "limit":100
}


response = requests.get(url, headers=headers, params=params)



tokenIdCount = 0

globalDict= dict()


while True:

    first_page = response.json()
    results = first_page.get('results')
    tokenIdCount += len(results)
    localDict = dict()
    for i in results:
        if i.get('owner') in globalDict:
            globalDict[i.get('owner')].append(i.get('token_id'))
        else:
            globalDict[i.get('owner')] = [i.get('token_id')]
    if first_page.get('next', None) is not None:
        response = requests.get(first_page['next'], headers=headers)
    else:
        break
data_list = [[owner, token_ids] for owner, token_ids in globalDict.items()]
json_data = json.dumps(data_list)
# print(data_list)
with open('data.json', "w+") as file:
    file.write(json_data + "\n")