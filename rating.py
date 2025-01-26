import streamlit as st
from groq import Groq
import base64

# Initialize Groq client
client = Groq(api_key="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")

def analyze_image_with_vision(image_bytes):
    """Direct image analysis using Vision LLM"""
    try:
        # Encode image
        base64_image = base64.b64encode(image_bytes).decode("utf-8")
        
        # Precise environmental analysis prompt
        prompt = """Sustainability DIAGNOSTIC PROTOCOL:
        - Analyze ONLY visible image contents
        - Provide objective, evidence-based assessment
        - Focus on direct environmental indicators and carbon offset indicators
        - Avoid speculative interpretations

        REQUIRED OUTPUT:
        1. Primary environmental activity being done in image in 1 short line 
        2. Potential ecological impact in 2 short and precise points
        3. Quantitative sustainability rating (1-100) just the rating out much out of 10 and in one line justify
        
        the ouput should be short and precise.
        """

        # Vision model analysis
        response = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": prompt},
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}"
                            }
                        }
                    ]
                }
            ],
            model="llama-3.2-11b-vision-preview"
        )
        
        return response.choices[0].message.content

    except Exception as e:
        return f"Analysis Error: {str(e)}"

def main():
    st.title("Environmental Impact Vision Analyzer")

    # Camera or file input
    camera_image = st.camera_input("Capture Environmental Scene")
    uploaded_file = st.file_uploader("Or Upload Image", type=["jpg", "jpeg", "png"])
    
    image_to_analyze = camera_image or uploaded_file
    
    if image_to_analyze is not None:
        # Display image
        st.image(image_to_analyze, caption="Analysis Subject", use_container_width=True)
        
        # Analyze image
        with st.spinner("Conducting Environmental Assessment..."):
            result = analyze_image_with_vision(image_to_analyze.getvalue())
        
        
        # Display results
        st.subheader("Environmental Diagnostic Report")
        st.write(result)

if __name__ == "__main__":
    main()