# **Focal**

## Table of Contents
- Overview  
- Product Spec  
- Wireframes  
- Schema  

---

## **Overview**

### **Description**  
**Focal** is a minimalist productivity app designed to help users stay focused by combining Pomodoro-style time tracking, goal-setting, ambient soundscapes, and distraction-blocking features. Users can set goals for each session, play soothing audio to maintain concentration, and block screen taps or notifications to avoid interruptions during deep work or study sessions.

---

### **App Evaluation**

**Category:**  
Productivity / Wellness / Education  

**Mobile:**  
Deeply mobile-native with timer, audio, push notifications, screen tap lock, and background play. Uses system-level distraction management and daily engagement features.  

**Story:**  
In a world full of distractions, people crave calm and structure. Focal gives them a tool to plan intentional deep work, stay grounded with calming sounds, and build better habits around focus and productivity.  

**Market:**  
Gen Z, university students, remote workers, ADHD/neurodivergent users, and productivity seekers. Niche but well-defined audience with proven market interest in Pomodoro and focus tools.  

**Habit:**  
Encourages daily planning, reflection, and focus sessions. Designed to integrate with routines (e.g., morning setup, midday sessions). Users actively create session goals and track progress.  

**Scope:**  
Clear MVP with achievable goals:
- Timer
- Goal input
- Audio player
- Distraction prevention  
Optional enhancements like session history, analytics, and syncing can come later.

---

## **Product Spec**

### 1. **User Stories (Required and Optional)**

#### ✅ Required Must-have Stories
- User can start a timer for focus (Pomodoro or custom duration)  
- User can input and tag a goal for the focus session  
- User can choose and play an ambient or binaural audio track  
- App blocks screen taps or accidental switching during the session  
- User receives a daily reminder to start their planned sessions  

#### ✨ Optional Nice-to-have Stories
- User can see a streak or habit history  
- User can see weekly time spent focusing and goal completion  
- User can connect to Apple Health/FitnessKit for focus tracking  
- User can share completed sessions or achievements with friends  
- User can choose calming visuals or background animations  

---

### 2. **Screen Archetypes**

- **Welcome / Login Screen**  
  - User can log in or skip login for local use  

- **Home / Planner Screen**  
  - User can plan daily focus sessions and goals  

- **Focus Session Screen**  
  - User can see timer countdown  
  - User hears selected audio  
  - Screen taps are disabled during session  
  - User can end session early or complete it  

- **Goal Input Modal**  
  - User can write a small goal before starting a session  

- **Audio Selection Screen**  
  - User can choose from a list of ambient or binaural sounds  

- **Daily Summary Screen**  
  - User can view completed sessions and goals  

---

### 3. **Navigation**

#### **Tab Navigation (Tab to Screen)**  
- **Home** – Plan and review daily sessions  
- **Focus** – Start and run focus sessions  
- **Profile** – (Optional) View streaks, settings, and audio choices  

#### **Flow Navigation (Screen to Screen)**  

**Welcome/Login Screen**  
→ Home  

**Home Screen**  
→ Goal Input Modal  
→ Focus Session  
→ Audio Selection  

**Focus Session Screen**  
→ Daily Summary (on completion)  
→ Home (if user ends session early)  

**Audio Selection Screen**  
→ Back to Home or Focus  

**Profile/Settings (optional)**  
→ Manage preferences, view streaks  

---

## **Wireframes**




---

## **[BONUS] Digital Wireframes & Mockups**
(Optional section for Figma or digital mockups)

---

## **Schema**
(To be completed in Unit 9)

### **Models**
- Session  
  - duration (Int)  
  - goalText (String)  
  - date (Date)  
  - soundTrack (String)  
  - isCompleted (Bool)  

- User (Optional)  
  - email  
  - password  
  - streakCount  
  - sessionHistory  

---

### **Networking**
TBD
