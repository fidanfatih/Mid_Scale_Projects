# streamlit run app.py

import streamlit as st
import pickle
import pandas as pd
from PIL import Image

# st.title('Telco Customer Churn Prediction')
# st.markdown("<h1 style='text-align: center; color: black;'>Telco Customer Churn Prediction</h1>", unsafe_allow_html=True)
im = Image.open("cover.png")
st.image(im, width=700)

html_temp = """
<div style="width:700px;background-color:tomato;padding:10px">
<h1 style="color:white;text-align:center;">Customer Churn Probability <br>Machine Learning Application<br/>(Demo)</h1>
</div>"""
st.markdown(html_temp,unsafe_allow_html=True)

# # images
# im = Image.open("image.png")
# st.image(im, width=700)

# @st.cache
# bir buyuk bir datatyi read_csv ile tekrar tekrar okutmamak icin hafuzada tutmasi icin st.cache kullanilir.
xgb_model = pickle.load(open("XGBoost.pkl","rb"))

# Features: ["Contract", "InternetService", "Dependents", "OnlineSecurity",'TechSupport',"PaymentMethod",'Partner','Tenure']

contract_list = ['Month-to-month', 'One year', 'Two year']
internetService_list = ['Fiber optic', 'DSL','No']
dependents_list = ['Yes','No']
onlineSecurity_list = ['Yes','No', 'No internet service']
techSupport_list = ['Yes','No', 'No internet service']
paymentMethod_list = ['Bank transfer (automatic)', 'Credit card (automatic)', 'Electronic check', 'Mailed check']
partner_list = ['Yes','No']
# Tenure: numerical

st.sidebar.header("Enter the Customer Information Below:")
contract = st.sidebar.radio("The contract term of the customer",(contract_list))
internetService = st.sidebar.radio("Customer’s internet service provider",(internetService_list))
dependents = st.sidebar.radio("Whether the customer is dependant or not",(dependents_list))
onlineSecurity = st.sidebar.radio("Whether the customer has online security or not",(onlineSecurity_list))
techSupport = st.sidebar.radio("Whether the customer has tech support or not",(techSupport_list))
paymentMethod = st.sidebar.radio("The Payment Method of the customer",(paymentMethod_list))
partner = st.sidebar.radio("Whether the customer has a partner or not",(partner_list))
tenure = st.sidebar.slider("Number of months the customer has stayed with the company (tenure)", 0,72,10, step=1)

my_dict = {"Contract":contract,
           "InternetService":internetService, 
           "Dependents":dependents, 
           "OnlineSecurity":onlineSecurity,
           "TechSupport":techSupport,
           'PaymentMethod':paymentMethod,
           'Partner':partner,
           'Tenure':tenure
            }

df = pd.DataFrame.from_dict([my_dict])
all_columns = ['SeniorCitizen', 'Tenure', 'MonthlyCharges', 'TotalCharges',
       'Gender_Male', 'Partner_Yes', 'Dependents_Yes', 'PhoneService_Yes',
       'MultipleLines_No phone service', 'MultipleLines_Yes',
       'InternetService_Fiber optic', 'InternetService_No',
       'OnlineSecurity_No internet service', 'OnlineSecurity_Yes',
       'OnlineBackup_No internet service', 'OnlineBackup_Yes',
       'DeviceProtection_No internet service', 'DeviceProtection_Yes',
       'TechSupport_No internet service', 'TechSupport_Yes',
       'StreamingTV_No internet service', 'StreamingTV_Yes',
       'StreamingMovies_No internet service', 'StreamingMovies_Yes',
       'Contract_One year', 'Contract_Two year', 'PaperlessBilling_Yes',
       'PaymentMethod_Credit card (automatic)',
       'PaymentMethod_Electronic check', 'PaymentMethod_Mailed check']
df = pd.get_dummies(df).reindex(columns=all_columns, fill_value=0)

# Table
def single_customer():
    my_dict = {"Contract":contract,
               "InternetService":internetService, 
               "Dependents":dependents, 
               "OnlineSecurity":onlineSecurity,
               "TechSupport":techSupport,
               'PaymentMethod':paymentMethod,
               'Partner':partner,
               'Tenure':tenure}
    df_table = pd.DataFrame.from_dict([my_dict])
#     st.table(df_table) 
    st.write('')
    st.dataframe(data=df_table, width=700, height=768)
    st.write('')

single_customer()

# Button
if st.button("Submit"):
    import time
    with st.spinner("ML Model is loading..."):
        my_bar=st.progress(0)
        for p in range(0,101,10):
            my_bar.progress(p)
            time.sleep(0.1)

        prediction_XGB = xgb_model.predict_proba(df)
        st.success(f'The Probability of the Customer Churn is %{round(prediction_XGB[0][0]*100,1)}')
#         if prediction_XGB[0]:
#             st.warning("The Customer is CHURN")
#         else:
#             st.success("The Customer is NOT CHURN")