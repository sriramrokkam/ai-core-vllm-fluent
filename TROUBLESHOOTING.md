# Troubleshooting: Application Not Appearing in AI Launchpad

## Current Issue
The `vllm-fluent` application is not appearing in AI Launchpad after Git repository sync.

## Checklist - Please Verify

### 1. Git Repository Status in AI Launchpad

Go to **ML Operations** → **Git Repositories** and check:

- [ ] Repository name: `ai-core-vllm-fluent` is listed
- [ ] Status shows: **Synced** or **Active** (green checkmark)
- [ ] Last sync time is recent (within last hour)
- [ ] No error messages displayed

**If you see errors, note them down!**

### 2. Resource Group

- [ ] You're viewing the correct Resource Group (check dropdown at top of AI Launchpad)
- [ ] The Git repository is registered in the SAME resource group you're currently viewing

### 3. Repository Configuration

Click on your Git repository and verify:

- [ ] **URL**: `https://github.com/sriramrokkam/ai-core-vllm-fluent` or `https://github.com/sriramrokkam/ai-core-vllm-fluent.git`
- [ ] **Revision/Branch**: `main` or `HEAD`
- [ ] **Path**: Empty or `/`

### 4. Check for Application Discovery

Some AI Core instances show discovered applications in the Git Repository details:

- [ ] Click on the repository
- [ ] Look for a tab/section called "Applications", "Scenarios", or "Discovered Resources"
- [ ] Check if `vllm` or `vllm-fluent` is listed there

---

## Common Issues & Solutions

### Issue 1: Wrong Resource Group

**Symptom:** Git repo is synced but no applications appear

**Solution:**
1. Note which resource group the Git repo is registered in
2. Switch to that resource group in the dropdown
3. Check Applications again

### Issue 2: Path Configuration

**Symptom:** Repository synced but AI Core can't find YAML files

**Solution:**
1. Go to Git Repository settings
2. Check the "Path" field
3. It should be either:
   - Empty (scans entire repo)
   - `/` (scans entire repo)
   - NOT set to a specific subdirectory

### Issue 3: Branch/Revision Mismatch

**Symptom:** Old or no applications discovered

**Solution:**
1. Verify the branch is set to `main` (not `master`)
2. Try changing to `HEAD` instead of `main`
3. Force a manual sync/refresh

### Issue 4: YAML Validation Errors

**Symptom:** Repository syncs but applications don't appear

**Solution:**
AI Core might be silently rejecting invalid YAML. Check:
1. Git repository details for any validation errors
2. Logs (if available in your AI Core instance)

---

## Alternative: Use AI Core API Directly

If the UI isn't working, we can create the configuration using the AI Core REST API.

### Prerequisites
You'll need:
- AI Core service key (client ID, client secret, auth URL, API URL)
- Resource group name

### Steps

1. **Get Access Token**
```bash
curl -X POST "https://YOUR-AUTH-URL/oauth/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=YOUR-CLIENT-ID" \
  -d "client_secret=YOUR-CLIENT-SECRET"
```

2. **List Scenarios** (to verify the template is loaded)
```bash
curl -X GET "https://YOUR-API-URL/v2/lm/scenarios" \
  -H "Authorization: Bearer YOUR-TOKEN" \
  -H "AI-Resource-Group: YOUR-RESOURCE-GROUP"
```

3. **If scenario exists, create configuration directly**
```bash
curl -X POST "https://YOUR-API-URL/v2/lm/configurations" \
  -H "Authorization: Bearer YOUR-TOKEN" \
  -H "AI-Resource-Group: YOUR-RESOURCE-GROUP" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "vllm-fluent-config",
    "scenarioId": "vllm-fluent",
    "executableId": "vllm-fluent",
    "parameterBindings": [
      {"key": "modelName", "value": "facebook/opt-125m"},
      {"key": "resourcePlan", "value": "infer.s"}
    ]
  }'
```

---

## Quick Fixes to Try

### Fix 1: Force Repository Refresh

1. Go to Git Repositories
2. Click on your repository
3. Look for **Sync**, **Refresh**, or **Reload** button
4. Click it
5. Wait 2-3 minutes
6. Check Applications again

### Fix 2: Update Repository Settings

1. Go to Git Repositories
2. Click **Edit** on your repository
3. Change **Revision** from `main` to `HEAD`
4. Save
5. Wait for sync
6. Check Applications

### Fix 3: Re-register Repository

1. **Delete** the current Git repository registration
2. **Re-register** with these exact settings:
   - URL: `https://github.com/sriramrokkam/ai-core-vllm-fluent`
   - Username: `sriramrokkam`
   - Password: Your GitHub Personal Access Token
   - Revision: `HEAD`
   - Path: (leave empty)
3. Wait 5-10 minutes
4. Check Applications

---

## Information Needed for Further Debugging

Please provide the following:

1. **Git Repository Status:**
   - What is the exact status message?
   - Any error messages?
   - Last sync timestamp?

2. **Resource Group:**
   - What resource group are you using?
   - Is it the same one where the Git repo is registered?

3. **AI Core Version:**
   - Which AI Core are you using? (AI Core Extended, AI Core Standard, etc.)
   - Any specific version number visible?

4. **Other Applications:**
   - Do you see ANY other applications in the Applications list?
   - If yes, which ones?

5. **Git Repository Details:**
   - Screenshot or exact text of the repository configuration
   - Any tabs/sections showing discovered resources?

---

## Next Steps

Based on your answers above, we can:

1. **If it's a configuration issue:** Fix the Git repository settings
2. **If it's a validation issue:** Fix the YAML templates
3. **If it's a UI issue:** Use the API directly to create configurations
4. **If it's a permissions issue:** Check your user roles and permissions

Please check the items in the checklist above and let me know what you find!
