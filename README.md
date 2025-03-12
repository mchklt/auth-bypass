# Header Manipulation Response Size Checker

This script helps to identify authentication bypass or access control vulnerabilities by analyzing response size differences when custom headers are applied to a URL. Unlike traditional methods that depend on status codes, this approach compares response content size to flag potential flaws in access control mechanisms.

### Features:
- **Header Testing**: Automatically tests a series of headers that could potentially bypass authentication or manipulate access controls.
- **Response Size Comparison**: Instead of relying on status codes, the script compares response size to a baseline to detect access control issues.
- **Customizable Headers**: The list of headers can easily be expanded or customized for different testing scenarios.
- **Output with Discrepancies**: Flags headers that cause notable content changes, helping you identify potential vulnerabilities.

---

## Usage

### Prerequisites:
- `curl` should be installed on your machine.

### Run the script:
```bash
./auth-bypass.sh <URL>
```

#### Example:
```bash
./auth-bypass.sh https://example.com
```

This will:
- Perform the request to the given URL without any custom headers.
- Then, it tests several custom headers and compares the response sizes.
- If the content size changes significantly with a certain header, it will flag it as potentially vulnerable.

### Example Output:
```bash
🔍 Testing headers on: https://example.com
📡 Getting baseline response...
🔄 Testing headers...
🔴 X-Forwarded-For                        +50db [content changed]
🟡 X-Role: admin                          +5db [content changed]
🔴 X-Real-IP: 192.168.1.1                 +70db [content changed]

💫 Analysis complete!
```

---

## How It Works

1. The script first captures the baseline response size from the given URL.
2. It then applies different custom headers, including:
   - Authorization headers (e.g., Basic Auth, Bearer Token)
   - IP manipulation headers (e.g., X-Forwarded-For, X-Client-IP)
   - Role and internal access headers (e.g., X-Role, X-Internal)
3. The script compares the response size for each header to the baseline.
4. Any discrepancies (content changes) are highlighted with their respective size differences.

---

## Contributing

If you'd like to contribute, feel free to fork this repository and submit a pull request. Improvements, bug fixes, and new header types are always welcome!

---
