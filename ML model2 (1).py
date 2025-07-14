# Import required libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, classification_report, roc_auc_score
from xgboost import XGBClassifier

# Load dataset
df = pd.read_csv("Customer_Data.csv")

# Create binary target from 'Customer_Status'
df['Churn'] = df['Customer_Status'].apply(lambda x: 1 if x == 'Churned' else 0)

# Drop irrelevant columns (leakage and ID fields)
df = df.drop(columns=['Customer_ID', 'Customer_Status', 'Churn_Category', 'Churn_Reason'])

# Drop missing values
df = df.dropna()

# One-hot encode categorical variables
df = pd.get_dummies(df, drop_first=True)

# Split into features and target
X = df.drop('Churn', axis=1)
y = df['Churn']

# Split into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Feature scaling
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train XGBoost Classifier
model = XGBClassifier(use_label_encoder=False, eval_metric='logloss', random_state=42)
model.fit(X_train_scaled, y_train)

# Predict
y_pred = model.predict(X_test_scaled)
y_proba = model.predict_proba(X_test_scaled)[:, 1]

# Evaluate
print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))
print("ROC AUC Score:", roc_auc_score(y_test, y_proba))

# Save predictions for Power BI
df['Predicted_Churn'] = model.predict(scaler.transform(X))
df['Churn_Probability'] = model.predict_proba(scaler.transform(X))[:, 1]
df.to_csv("Churn_Prediction_Output.csv", index=False)
print("\nChurn predictions saved to 'Churn_Prediction_Output.csv'")
