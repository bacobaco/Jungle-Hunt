import tkinter as tk
from tkinter import ttk, messagebox

# Dictionnaire des couleurs Hi-Res de l'Apple II
#https://www.mrob.com/pub/xapple2/colors.html
HGR_COLORS = {
    'black': (0, 0, 0),
    'white': (255, 255, 255),
    'green': (20, 245, 60),
    'orange': (255, 106, 60),
    'blue': (20, 207, 253),
    'violet': (255, 68, 253)
}

def hgr_to_rgb(byte_stream): 
    # Grosse galère de plusieurs jours pour trouver la bonne et simple interprétation du flux de bits des 7 bits (inversés) des octets HGR
    # Après beaucoup de lecture le plus simple et https://www.xtof.info/hires-graphics-apple-ii.html :
    # il faut prendre les bits deux par deux et si il y a une transition (sans bit adjacent allumé) alors il y au une couleur sur le bit allumé
    # pour idéaliser l'écran couleur et éviter des trous noirs à coté de la couleur:
    # on va mettre une couleur "aussi" sur le bit=0 de la prochaine transition ou la suivante (ligne de couleur)
    #
    colors = []
    bit_stream = []

    # Génération du flux de bits en ignorant le bit 7
    for byte in byte_stream:
        for i in range(7):  # Bits 0 à 6 seulement
            bit_stream.append((byte >> i) & 1)

    # Parcours par paires de bits avec gestion des bits adjacents
    for i in range(0, len(bit_stream) - 1, 2):  # Paires de bits
        bit1 = bit_stream[i]
        bit2 = bit_stream[i + 1]

        # Calcul de l'index d'octet actuel et du bit 7
        current_byte_index = i // 7  # Index de l'octet (chaque octet contient 7 bits valides)
        if current_byte_index < len(byte_stream):
            is_high_bit_set = (byte_stream[current_byte_index] >> 7) & 1  # Bit 7 (NTSC shift)
        else:
            break

        # Bits adjacents (gauche et droite)
        next_bit = bit_stream[i + 2] if i + 2 < len(bit_stream) else 0
        prev_bit = bit_stream[i - 1] if i > 0 else 0

        # Décodage des couleurs en fonction des transitions et du bit 7
        if bit1 == 0 and bit2 == 0:
            colors.append(HGR_COLORS['black'])  # 00 -> Deux pixels noirs
            colors.append(HGR_COLORS['black'])
        elif bit1 == 1 and bit2 == 1:
            colors.append(HGR_COLORS['white'])  # 11 -> Deux pixels blancs
            colors.append(HGR_COLORS['white'])
        elif bit1 == 0 and bit2 == 1:
            if next_bit == 1:
                colors.append(HGR_COLORS['black'])  if prev_bit == 0 else colors.append(HGR_COLORS['orange'] if is_high_bit_set else HGR_COLORS['green'])  # on garde la couleur si on avait une couleur juste avant
                colors.append(HGR_COLORS['white'])
            else:
                colors.append(HGR_COLORS['black'] if prev_bit==0 else HGR_COLORS['orange'] if is_high_bit_set else HGR_COLORS['green']) 
                colors.append(HGR_COLORS['orange'] if is_high_bit_set else HGR_COLORS['green'])
        elif bit1 == 1 and bit2 == 0:
            if prev_bit == 1:
                colors.append(HGR_COLORS['white'])  # 10 avec bit adjacent -> blanc et noir
                colors.append(HGR_COLORS['black'])  if next_bit == 0 else colors.append(HGR_COLORS['blue'] if is_high_bit_set else HGR_COLORS['violet'])
            else:
                colors.append(HGR_COLORS['blue'] if is_high_bit_set else HGR_COLORS['violet'])
                colors.append(HGR_COLORS['black'] if next_bit == 0 else HGR_COLORS['blue'] if is_high_bit_set else HGR_COLORS['violet'])

    return colors
def draw_grid_with_line_numbers(canvas_width, canvas_height, zoom):
    # Dessiner la grille
    if show_grid.get():
        bytes_per_line = int(bytes_spinbox.get())
        # Lignes verticales
        for x in range(0, canvas_width * zoom + 1, zoom):
            canvas.create_line(x, 0, x, canvas_height * zoom, fill='gray', width=1)
        # Lignes horizontales et numéros de lignes
        for y in range(0, canvas_height * zoom , zoom):
            canvas.create_line(0, y, canvas_width * zoom, y, fill='gray', width=1)
            # Dessiner le numéro de ligne à droite de la grille
            canvas.create_text(canvas_width * zoom + 10, y + zoom // 2+1, anchor='w', text=str("%2d:%3d=%02X" % (y // zoom+1,(y//zoom+1)*bytes_per_line,(y//zoom+1)*bytes_per_line)), fill='white', font=("Arial",8 ))



# Fonction pour mettre à jour l'affichage
# Fonction pour mettre à jour l'affichage
def update_display():
    bytes_per_line = int(bytes_spinbox.get())
    data_to_display = sprite_data.copy()  # Copie pour ne pas modifier la liste originale
    if invert_lines.get():
        # Inverse l'ordre des lignes en prenant des blocs de bytes_per_line octets
        data_to_display = [
            data_to_display[i:i + bytes_per_line]
            for i in range(len(data_to_display)-len(data_to_display)%bytes_per_line - bytes_per_line, -1, -bytes_per_line)
        ]
        # Aplatit la liste pour la remettre en une seule dimension
        data_to_display = [octet for sublist in data_to_display for octet in sublist]
    afficher_hgr(data_to_display, bytes_per_line, zoom, color_mode)

class SpriteDataEditor:
    def __init__(self, parent, sprite_data):
        self.window = tk.Toplevel(parent)
        self.window.title("Éditeur de données Sprite")
        self.sprite_data = list(sprite_data)  # Copie des données
        self.original_sprite_data = list(sprite_data)  # Stocke une copie des données originales
        self.create_widgets()
        
    def create_widgets(self):
        # Frame principal
        main_frame = ttk.Frame(self.window, padding="5")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Frame pour la liste et les boutons de défilement
        list_frame = ttk.Frame(main_frame)
        list_frame.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        
        # Listbox avec scrollbar
        scrollbar = ttk.Scrollbar(list_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.listbox = tk.Listbox(list_frame, width=50, height=20, yscrollcommand=scrollbar.set)
        self.listbox.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        scrollbar.config(command=self.listbox.yview)
        
        # Frame pour les boutons d'édition
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(side=tk.BOTTOM, padx=5)
        
        # Frame pour l'entrée de nouvelle valeur
        entry_frame = ttk.Frame(button_frame)
        entry_frame.pack(fill=tk.X, pady=5)
        
        ttk.Label(entry_frame, text="Nouvelle valeur (hex):").pack(side=tk.BOTTOM)
        self.new_value = ttk.Entry(entry_frame, width=10)
        self.new_value.pack(side=tk.BOTTOM, padx=5)
        
        # Boutons
        ttk.Button(button_frame, text="Modifier", command=self.modify_value).pack(fill=tk.X, pady=2)
        ttk.Button(button_frame, text="Ajouter", command=self.add_value).pack(fill=tk.X, pady=2)
        ttk.Button(button_frame, text="Supprimer", command=self.delete_value).pack(fill=tk.X, pady=2)
        ttk.Button(button_frame, text="Monter", command=self.move_up).pack(fill=tk.X, pady=2)
        ttk.Button(button_frame, text="Descendre", command=self.move_down).pack(fill=tk.X, pady=2)
        
        # Bouton Restaurer
        ttk.Button(button_frame, text="Restaurer d'origine", command=self.restore_original_sprite).pack(fill=tk.X, pady=10)
        
        # Bouton Appliquer
        ttk.Button(button_frame, text="Appliquer", command=self.apply_changes).pack(fill=tk.X, pady=10)
        
        # Remplir la listbox
        self.refresh_listbox()
    
    def refresh_listbox(self):
        self.listbox.delete(0, tk.END)
        for i, value in enumerate(self.sprite_data):
            self.listbox.insert(tk.END, f"[{i:02d}] 0x{value:02X}")
    
    def modify_value(self):
        selection = self.listbox.curselection()
        if not selection:
            messagebox.showwarning("Avertissement", "Veuillez sélectionner une valeur à modifier")
            return
        
        try:
            new_val = int(self.new_value.get(), 16)
            if 0 <= new_val <= 0xFF:
                self.sprite_data[selection[0]] = new_val
                self.refresh_listbox()
            else:
                messagebox.showwarning("Erreur", "La valeur doit être entre 0x00 et 0xFF")
        except ValueError:
            messagebox.showwarning("Erreur", "Valeur hexadécimale invalide")
    
    def add_value(self):
        try:
            new_val = int(self.new_value.get(), 16)
            if 0 <= new_val <= 0xFF:
                selection = self.listbox.curselection()
                if selection:
                    self.sprite_data.insert(selection[0], new_val)
                else:
                    self.sprite_data.append(new_val)
                self.refresh_listbox()
            else:
                messagebox.showwarning("Erreur", "La valeur doit être entre 0x00 et 0xFF")
        except ValueError:
            messagebox.showwarning("Erreur", "Valeur hexadécimale invalide")
    
    def delete_value(self):
        selection = self.listbox.curselection()
        if not selection:
            messagebox.showwarning("Avertissement", "Veuillez sélectionner une valeur à supprimer")
            return
        
        self.sprite_data.pop(selection[0])
        self.refresh_listbox()
    
    def move_up(self):
        selection = self.listbox.curselection()
        if not selection or selection[0] == 0:
            return
        
        idx = selection[0]
        self.sprite_data[idx], self.sprite_data[idx-1] = self.sprite_data[idx-1], self.sprite_data[idx]
        self.refresh_listbox()
        self.listbox.selection_set(idx-1)
    
    def move_down(self):
        selection = self.listbox.curselection()
        if not selection or selection[0] >= len(self.sprite_data) - 1:
            return
        
        idx = selection[0]
        self.sprite_data[idx], self.sprite_data[idx+1] = self.sprite_data[idx+1], self.sprite_data[idx]
        self.refresh_listbox()
        self.listbox.selection_set(idx+1)
    
    def restore_original_sprite(self):
        """Restaure les données du sprite d'origine."""
        self.sprite_data = list(self.original_sprite_data)  # Récupère la copie des données d'origine
        self.refresh_listbox()  # Met à jour l'affichage de la liste
    
    def apply_changes(self):
        global sprite_data
        sprite_data = list(self.sprite_data)
        update_display()

def open_sprite_editor():
    SpriteDataEditor(fenetre, sprite_data)

def extract_bytes_from_listing(listing):
    """Extrait les octets valides (00-FF) d'un listing 6502."""
    bytes_list = []
    lines = listing.splitlines()
    for line in lines:
        parts = line.split(':')
        if len(parts) == 2:
            bytes_str = parts[1].strip().split()
            for byte_str in bytes_str:
                if len(byte_str) == 2 and byte_str.isalnum():  # Vérifie si c'est un octet valide
                    bytes_list.append(int(byte_str, 16))
    return bytes_list

def open_data_entry_window():
    """Ouvre une fenêtre pour entrer des données hexadécimales."""
    data_entry_window = tk.Toplevel(fenetre)
    data_entry_window.title("Saisir données Sprite sous forme de listing 6502 directement")

    # Zone de texte pour le listing 6502
    listing_text = tk.Text(data_entry_window, height=10, wrap=tk.WORD)
    listing_text.pack(padx=10, pady=10)

    # Bouton pour valider les données
    def validate_data():
        global sprite_data
        listing = listing_text.get("1.0", "end-1c")
        new_sprite_data = extract_bytes_from_listing(listing)
        sprite_data = new_sprite_data
        update_display()
        data_entry_window.destroy()

    ttk.Button(data_entry_window, text="Valider", command=validate_data).pack(pady=5)

# Fonction pour afficher les données HGR sur le canvas, adaptée pour plusieurs octets par ligne
def afficher_hgr(data, bytes_per_line, zoom=10, color_mode='color'):
    # Calculer la largeur et la hauteur du canvas en pixels
    canvas_width = bytes_per_line * 7
    canvas_height = len(data) // bytes_per_line

    # Créer une image vide
    image = tk.PhotoImage(width=canvas_width, height=canvas_height)

    # Décoder chaque ligne d'octets HGR en couleurs RGB
    for y in range(canvas_height):
        for x in range(0, canvas_width, 7 * bytes_per_line):
            # Extraire les octets de la ligne actuelle
            byte_stream = data[(y * bytes_per_line):(y * bytes_per_line) + bytes_per_line]

            # Décoder les octets en fonction du mode couleur/N&B
            if color_mode == 'bw':
                for i in range(bytes_per_line * 7):
                    bit = (byte_stream[i // 7] >> (i % 7)) & 1
                    color = HGR_COLORS['white'] if bit else HGR_COLORS['black']
                    color_string = rgb_to_string(color)
                    image.put(color_string, (x + i, y))
            else:
                colors = hgr_to_rgb(byte_stream)
                for i, color in enumerate(colors):
                    color_string = rgb_to_string(color)
                    image.put(color_string, (x + i, y))

    # Agrandir l'image en fonction du zoom
    zoomed_image = image.zoom(zoom, zoom)

    # Effacer le canvas et afficher l'image
    canvas.delete("all")
    canvas.create_image(0, 0, anchor=tk.NW, image=zoomed_image)
    canvas.image = zoomed_image  # Préserver la référence de l'image
    # Appelle la fonction pour dessiner la grille avec numéros de ligne
    draw_grid_with_line_numbers(canvas_width, canvas_height, zoom)


# Fonction pour convertir un tuple RGB en chaîne de caractères hexadécimale
def rgb_to_string(rgb):
    return "#%02x%02x%02x" % rgb

# Fonction pour augmenter le zoom
def zoom_in():
    global zoom
    zoom += 1
    update_display()

# Fonction pour diminuer le zoom
def zoom_out():
    global zoom
    if zoom > 1:
        zoom -= 1
    update_display()

# Fonction pour basculer entre les modes couleur et noir et blanc
def toggle_color_mode():
    global color_mode
    color_mode = 'bw' if color_mode == 'color' else 'color'
    update_display()

# Fonction pour basculer l'affichage de la grille
def toggle_grid():
    update_display()

# Données du sprite (exemple de données Hi-Res)
sprite_data = [
    0xBF, 0xC0, 0x81, 0x80, 0xBF, 0xE0, 0x81, 0x80,
    0xB8, 0xF4, 0x81, 0x80, 0xA0, 0xE4, 0x81, 0x80,
    0xA0, 0x84, 0x80, 0x80, 0xA0, 0x9F, 0x80, 0x80,
    0xBC, 0xBE, 0x80, 0x80, 0xFC, 0xBF, 0x83, 0x80,
    0xF8, 0xFF, 0x83, 0x80, 0xF0, 0xBF, 0x83, 0x80,
    0x80, 0x80, 0x83, 0x80, 0xE0, 0xBF, 0x83, 0x80,
    0xFE, 0xBF, 0x83, 0x80, 0xFE, 0xFF, 0x83, 0x80,
    0xE6, 0xFF, 0x81, 0x80, 0xE0, 0xFF, 0x81, 0x80,
    0xC0, 0xFF, 0x80, 0x80, 0x80, 0x94, 0x80, 0x80,
    0x80, 0x95, 0x80, 0x80, 0x80, 0x95, 0x80, 0x80,
    0xF8, 0xFF, 0x81, 0x80, 0xE0, 0xB6, 0x80, 0x80,
    0xC0, 0x9F, 0x80, 0x80
]
# Classe pour créer la bulle d'aide
class ToolTip:
    def __init__(self, widget, text):
        self.widget = widget
        self.text = text
        self.tooltip = None
        widget.bind("<Enter>", self.show_tooltip)
        widget.bind("<Leave>", self.hide_tooltip)

    def show_tooltip(self, event=None):
        # Créer une fenêtre pour la bulle d'aide
        self.tooltip = tk.Toplevel(self.widget)
        self.tooltip.wm_overrideredirect(True)  # Supprimer les bordures de la fenêtre
        self.tooltip.wm_geometry(f"+{self.widget.winfo_rootx() + 20}+{self.widget.winfo_rooty() + 20}")
        label = tk.Label(self.tooltip, text=self.text, background="yellow", relief="solid", borderwidth=1, padx=5, pady=3 ,justify="left")
        label.pack(anchor="w")

    def hide_tooltip(self, event=None):
        if self.tooltip:
            self.tooltip.destroy()
        self.tooltip = None
# Créer une fenêtre Tkinter
fenetre = tk.Tk()
fenetre.title("Affichage HGR en couleur et noir & blanc")

# Frame pour les contrôles
control_frame = ttk.Frame(fenetre)
control_frame.pack(side=tk.TOP, fill=tk.X, padx=5, pady=5)

# Bouton pour ouvrir la fenêtre de saisie des données en forme de listing 6502
data_entry_button = ttk.Button(control_frame, text="Saisir Listing 6502", command=open_data_entry_window)
data_entry_button.pack(side=tk.LEFT, padx=5)
# Ajouter une bulle d'aide au bouton
tooltip = ToolTip(data_entry_button, "Mettre du code désassemblé sous forme de listing 6502.\
    \nSoit sous  la forme de listing désassemblé: \n82CD:75 00       ADC $00,X\n82CF:70 0E       BVS $82DF\n82D1:37      ???\
        \nou soit sous la forme de listing hexadécimale (format <adresse>:<hex> <hex> ...):\n 2000:55 22 FF 99 66 ...")

# Spinbox pour le nombre d'octets par ligne
ttk.Label(control_frame, text="Octets par ligne:").pack(side=tk.LEFT, padx=5)
bytes_spinbox = ttk.Spinbox(control_frame, from_=1, to=40, width=5)
bytes_spinbox.pack(side=tk.LEFT, padx=5)
bytes_spinbox.set(4)  # Valeur par défaut

# Variable pour l'état de l'inversion des lignes
invert_lines = tk.BooleanVar()
invert_lines.set(False)  # Inversion activée par défaut
# Checkbox pour l'inversion des lignes
invert_checkbox = ttk.Checkbutton(control_frame, text="Inverser lignes", variable=invert_lines, command=update_display)
invert_checkbox.pack(side=tk.LEFT, padx=5)

# Ajout du bouton d'édition dans le control_frame après les autres boutons
edit_button = ttk.Button(control_frame, text="Éditer données", command=open_sprite_editor)
edit_button.pack(side=tk.LEFT, padx=5)

# Frame pour les contrôles
control_frame = ttk.Frame(fenetre)
control_frame.pack(side=tk.BOTTOM, fill=tk.X, padx=5, pady=5)
# Variable pour l'état de la grille
show_grid = tk.BooleanVar()
show_grid.set(True)  # Grille activée par défaut

# Boutons de contrôle
zoom_in_button = ttk.Button(control_frame, text="Zoom +", command=zoom_in)
zoom_in_button.pack(side=tk.LEFT, padx=5)

zoom_out_button = ttk.Button(control_frame, text="Zoom -", command=zoom_out)
zoom_out_button.pack(side=tk.LEFT, padx=5)

toggle_color_button = ttk.Button(control_frame, text="Mode Couleur/NB", command=toggle_color_mode)
toggle_color_button.pack(side=tk.LEFT, padx=5)

# Checkbox pour la grille
grid_checkbox = ttk.Checkbutton(control_frame, text="Afficher grille", variable=show_grid, command=toggle_grid)
grid_checkbox.pack(side=tk.LEFT, padx=5)

# Créer un canvas
canvas = tk.Canvas(fenetre, bg='black')
canvas.pack(fill=tk.BOTH, expand=True)

# Variables globales pour le zoom et le mode de couleur
zoom = 10
color_mode = 'color'

# Configurer le callback pour le Spinbox
bytes_spinbox.config(command=update_display)

# Afficher l'image initiale
update_display()

# Lancer la boucle principale de la fenêtre
fenetre.mainloop()