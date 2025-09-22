# Copy-NodePaths-for-AI-Prompt
Adds context (right mouse click) menu item to copy node tree structure to clipboard in an AI-friendly format, speeds up the automation process.

<img width="807" height="579" alt="image" src="https://github.com/user-attachments/assets/e2cc882c-f8e8-4976-9c95-4d9dd5fb57d6" />


Example for the Node and its whole Family Tree:


      sentry-gun
      ├─ Stand_arma_0
      ├─ CollisionShape3D
      └─ MGMain
         ├─ MGMain_arma_0
         ├─ Swivel_arma_0
         └─ CollisionShape3D

Example for the 1st gen children:


      sentry-gun
      ├─ Stand_arma_0
      ├─ CollisionShape3D
      └─ MGMain

Example for the Node and its whole Family Tree with Node types:


      sentry-gun [StaticBody3D]
      ├─ Stand_arma_0 [MeshInstance3D]
      ├─ CollisionShape3D [CollisionShape3D]
      └─ MGMain [StaticBody3D]
         ├─ MGMain_arma_0 [MeshInstance3D]
         ├─ Swivel_arma_0 [MeshInstance3D]
         └─ CollisionShape3D [CollisionShape3D]

Example for the 1st gen children with Node types:


      sentry-gun [StaticBody3D]
      ├─ Stand_arma_0 [MeshInstance3D]
      ├─ CollisionShape3D [CollisionShape3D]
      └─ MGMain [StaticBody3D]


Please leave a star on this repo if you find this useful, thank you and enjoy. :)


